var app = angular.module('tangledControlsApp', [
    'ui.bootstrap',
    'ui.bootstrap-slider'
])

.controller('tangledControlsCtrl', function($scope, TweakService) {
    $scope.config = {
        server: {
            port: 12000,
            host: '127.0.0.1'
        },
        client: {
            port: 15000,
            host: '127.0.0.1'
        }
    };
    TweakService.connectToBridge();
    $scope.connected = false;
    $scope.connect = function() {
        TweakService.config($scope.config);
        TweakService.connectToServer()
            .then(function() {
                $scope.connected = true;
            })
        ;
    };
    $scope.options = TweakService.getOptions();
})

.directive('tangledButton', function() {
    return {
        restrict: 'ACE',
        scope: {
            commandName: '@action'
        },
        template: '<button type="button" class="btn" ng-click="sendCommand()">{{commandName}}</button>',
        controller: function($scope, TweakService) {
            $scope.options = TweakService.getOptions();
            $scope.sendCommand = function() {
                TweakService.sendMessage($scope.commandName);
            };
        }
    };
})

.directive('tangledSlider', function() {
    return {
        restrict: 'ACE',
        scope: {
            variableName: '@variable',
            min: '@min',
            max: '@max',
            initial: '@initial',
            step: '@step'
        },
        template: '<label>{{variableName}}</label><slider ng-model="options[variableName]" min="{{min}}" step="{{step}}" max="{{max}}" value="{{initial}}"></slider>',
        controller: function($scope, TweakService) {
            $scope.options = TweakService.getOptions();
            // ng-change doesn't seem to work for the slider directive, so we watch the variable passed as ng-model
            $scope.$watch('options.' + $scope.variableName, function() {
                if(typeof $scope.options !== "undefined" && typeof $scope.options[$scope.variableName] !== "undefined") {
                    $scope.sendValue();
                }
            });
            $scope.sendValue = function() {
                TweakService.set($scope.variableName, $scope.options[$scope.variableName]);
            };
        }
    };
})

.directive('tangledToggle', function() {
    return {
        restrict: 'ACE',
        scope: {
            variableName: '@variable'
        },
        template: '<button type="button" ng-change="sendValue()" ng-model="options[variableName]" class="btn" ng-class="{\'btn-primary\' : options[variableName]}" btn-checkbox btn-checkbox-true="1" btn-checkbox-false="0">{{variableName}}</button>',
        controller: function($scope, TweakService) {
            $scope.options = TweakService.getOptions();
            $scope.sendValue = function() {
                TweakService.set($scope.variableName, $scope.options[$scope.variableName]);
            };
        }
    };
})

.service('TweakService', function( $q ) {
    var options = {
        attraction: 0,
        minAttraction: -1,
        maxAttraction: 1,
        minNodes: 300,
        maxNodes: 2000,
        polygons: 2,
        minLerpLevels: 0,
        maxLerpLevels: 5,
        lerpLevels: 1,
        voronoi: true
    };
    var socket;
    return {
        config: function(configObject) {
            socket.emit('config', configObject);
        },
        connectToBridge: function() {
            socket = io.connect('http://127.0.0.1', { port: 8081, rememberTransport: false});
            console.log('Connecting to the bridge');
            socket.on('message', function(obj) {
                //console.log(obj);
            });
        },
        connectToServer: function() {
            var deferred = $q.defer();
            socket.emit('connect');
            console.log('Connecting to the server');
            socket.on('message', function(message) {
                console.log(message);
                if(message[0] === "/connect") {
                    deferred.resolve();
                }
                else {
                    if(message.length > 1) {
                        var option = message[0].substring(1, message[0].length),
                            value = message[1];
                        console.log(option, value);
                        options[option] = value;
                    }
                }
            });
            return deferred.promise;
        },
        getOptions: function() {
            return options;
        },
        sendMessage: function(variableName) {
            socket.emit('message', '/' + variableName);
        },
        set: function(variableName, value) {
            options[variableName] = value;
            socket.emit('set', variableName, value);
        }
    };
})

;