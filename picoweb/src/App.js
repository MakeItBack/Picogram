import React, { Component } from 'react';
import './App.css';
import Auth from '@aws-amplify/auth';
import Analytics from '@aws-amplify/analytics';
import awsconfig from './aws-exports';


Auth.configure(awsconfig);
Analytics.configure(awsconfig);


class App extends Component {
  constructor(props) {
    super(props);
    Analytics.record('AWS Amplify Course Event');


    Analytics.record({
        name: 'Course',
        attributes: { tech: 'AWS Amplify', author: 'Bear' }
    });
    Analytics.record({
        name: 'Course',
        attributes: { tech: 'AWS IAM', author: 'Bear' }
    });
    console.log("test");
  }


  render() {
    return (
      <div className="App">
        <div className="App-intro">
        </div>
      </div>
    );
  }
}


export default App;