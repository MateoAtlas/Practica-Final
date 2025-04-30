// pubsub.js

const events = {};

const subscribe = (eventName, callback) => {
    if (!events[eventName]) {
        events[eventName] = [];
    }
    events[eventName].push(callback);
    return () => {
        events[eventName] = events[eventName].filter(cb => cb !== callback);
    };
};

const publish = (eventName, data) => {
    if (events[eventName]) {
        events[eventName].forEach(callback => callback(data));
    }
};

export { subscribe, publish }; // Exportamos las funciones correctamente
