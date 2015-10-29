/**
 * Created by Administrator on 2015/9/16.
 */

var _ = {
    longitude:'',
    latitude:'',
    ak:'XGPCTIpuPGvqq8eY0g7lPU7l',
    width:0,
    height:0
}

function navLocation(callback){
    if (_.longitude && _.latitude){
        callback(_.longitude,_.latitude);
    }else if ( navigator.geolocation ) {
        function success(pos) {
            _.longitude = pos.coords.longitude.toFixed(7);
            _.latitude = pos.coords.latitude.toFixed(7);

            callback(_.longitude, _.latitude);

        }
        function fail(error) {
            _.longitude = '113.7654429';
            _.latitude = '34.7666494';
            callback(_.longitude,_.latitude);
        }

        navigator.geolocation.getCurrentPosition(success, fail, {maximumAge: 500000, enableHighAccuracy:true, timeout: 6000});
    }
}

