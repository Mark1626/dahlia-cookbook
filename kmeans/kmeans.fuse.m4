define(`npoints', 16)dnl
define(`nclusters', 4)dnl
define(`nfeatures', 4)dnl
define(`l_cluster_sz', eval(((nclusters * nfeatures + 15) / 16) * 16))dnl
define(`nparallel_pts', 2)dnl
dnl
define(`cluster_sz', eval(nclusters*nfeatures))dnl
define(`feature_cnt', eval(npoints*nfeatures))dnl

def load_clusters(
  clusters_int: ubit<32>[l_cluster_sz],
  clusters: ubit<32>[cluster_sz], points: ubit<32>
) = {
  for (let i=0..cluster_sz) {
    if (i < points) {
      clusters[i] := clusters_int[i];
    }
  }
}

def load_features(
  features_int: ubit<32>[feature_cnt],
  features: ubit<32>[nparallel_pts][nfeatures],
  feature_offset: ubit<32>,
  nfeatures_int: ubit<32>
) = {
  for (let p:ubit<10>=0..nparallel_pts) {
    for (let j:ubit<10>=0..nfeatures) {
      let idx: ubit<32> = nfeatures_int*p + j;
      features[p][j] := features_int[feature_offset + idx];
    }
  }
}

decl clusters_int: ubit<32>[cluster_sz];
decl features_int: ubit<32>[feature_cnt];

decl membership_int: ubit<32>[feature_cnt];
decl new_centers_int: ubit<32>[feature_cnt];

decl nclusters_int: ubit<16>;
decl nfeatures_int: ubit<16>;
decl npoints_int: ubit<32>;

decl feature_offset_int: ubit<32>;
decl members_offset_int: ubit<32>;

{
  // proc_membership
  let clusters: ubit<32>[l_cluster_sz];
  // view clusters_sh = clusters[_: bank 1];

  let points = nclusters_int * nfeatures_int;

  // load clusters
  load_clusters(clusters_int, clusters, points);

  ---

  let feature_offset: ubit<32> = 0;
  for (let pt=0..npoints) {
    let features: ubit<32>[nparallel_pts bank nparallel_pts][nfeatures];

    view features_sh =  features[_: bank 1][_:];

    // load features
    load_features(features_int, features_sh, feature_offset, nfeatures_int);

    feature_offset += nfeatures_int * nparallel_pts;

    let index: ubit<7>[nparallel_pts bank nparallel_pts];
    let min_dist: ubit<32>[nparallel_pts bank nparallel_pts];
    let dist: ubit<32>[nparallel_pts bank nparallel_pts];

    let new_dist: ubit<32>[nparallel_pts bank nparallel_pts];
    let new_min_dist: ubit<32>[nparallel_pts bank nparallel_pts];

    for (let p=0..nparallel_pts) unroll nparallel_pts {
      dist[p] := 0;
      new_dist[p] := 0;
      min_dist[p] := 0;
      new_min_dist[p] := 0;
      index[p] := 0;
    }

    ---

    // compute membership
    let offset: ubit<16> = 0;
    for (let c=0..nclusters) {
      for (let f=0..nfeatures) pipeline {
        for (let p=0..nparallel_pts) unroll nparallel_pts {
          let diff = features[p][f] - clusters[offset + f];
          new_dist[p] := dist[p] + diff * diff;
          min_dist[p] := new_min_dist[p];
        } // loop p
      } // loop f

      ---

      // Update index
      for (let p=0..nparallel_pts) unroll nparallel_pts {
        if (new_dist[p] < min_dist[p]) {
            new_min_dist[p] := new_dist[p];
            index[p] := c;
        }
        dist[p] := 0;
      } // loop p

      offset += nfeatures_int;
    }  // loop c

    // proc new centers

    // Write new index
    // index[p];
    // features[f][p]

    let l_new_centers: ubit<32>[l_cluster_sz];
    let l_new_centers_update: ubit<32>[l_cluster_sz];
    // TODO: This could be moved up
    for (let i=0..l_cluster_sz) {
      l_new_centers[i] := 0;
    }

    // 
    let f:ubit<16> = nfeatures;
    while (f < nfeatures_int) pipeline {
      for (let p=0..nparallel_pts) unroll nparallel_pts {
        let idx = index[p] * nfeatures_int + f;
        l_new_centers_update[idx] := l_new_centers[idx] + features[p][f];
      } // loop p
      f += 1;
    }

  } // loop pt

  // TODO: Without the dataflow pragma should the loops be combined?
  // proc_new_centers

  let l_new_centers: ubit<32>[l_cluster_sz];

  

  ---

  /*
  for (let i=0..npoints) {
    let l_index: ubit<7>[nparallel_pts];
    for (let p=0..nparallel_pts) unroll nparallel_pts {
      for (let f=0..nfeatures) {
        // should occur at f = 0
        // l_index[p] = index
        
        l_new_centers[index * nfeatures + f] += feature;
      }
    }

    membership[offset + i] := index;
  }
  */

}
