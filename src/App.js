import 'bootstrap/dist/css/bootstrap.css';
import React, { Component } from 'react';
import bingo from './giphy.webp';
import oops from './oops.gif'
import _ from 'lodash';
import './App.css';

let data = []
_.forEach([0,1,2,3,4,5], i => { data = data.concat(require(`./test.q.${i}.json`)) })
let data1 = _.sample(data)

function Choice(props) {
  return (
    <tr key={`${props.key}r`}>
      <td
        onClick={props.onClick}
        key={props.key}
        className={props.active ? 'text-success' : '' }>{props.name}</td>
    </tr>
  )
}

function ResultImg(props) {
  if(props.result === null) {
    return ''
  }

  return (
    <img src={props.result ? bingo : oops}
          width='100%'
          alt='result' />
  )
}

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      question: data1['question'],
      choices: data1['choices'].map ( ch => [false, ch]),
      num: data1['qnum'],
      ans: data1['ans'],
      answer: data1['answer'],
      result: null
    }

    this.handleClick = this.handleClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleShuffle = this.handleShuffle.bind(this);
  }
  handleClick(e) {
    let choices = this.state.choices
    choices[e][0] = !choices[e][0]
    this.setState({
      question: this.state.question,
      num: this.state.num,
      ans: this.state.ans,
      choices: choices
    })
  }

  handleSubmit() {
    let choiced = _.filter(this.state.choices, item => item[0] )
    choiced = choiced.map( item => item[1].match(/^([A-H]) *./)[1] )
    if(this.state.ans.sort().toString() === choiced.sort().toString()) {
      this.setState({ result: true })
    } else {
      this.setState({ result: false })
    }
  }

  handleShuffle() {
    let d = _.sample(data)
    this.setState({
      question: d['question'],
      choices: d['choices'].map ( ch => [false, ch]),
      num: d['qnum'],
      ans: d['ans'],
      answer: d['answer'],
      result: null
    })
  }

  render() {
    this.choices = this.state.choices.map( (ch, i) =>
      <Choice
        onClick={ () => this.handleClick(i) }
        key={i}
        active={ch[0]}
        name={ch[1]}/>)

    return (
      <div className="App bg-light">
        <header className="App-header">
          <div className="col-lg-6 col-12 mx-2 my-3 p-3 bg-white rounded shadow-sm">
            <ResultImg result={this.state.result} />
            <table className="table table-borderless">
              <thead><tr><th>{this.state.question}</th></tr></thead>
              <tbody>
                { this.choices }
              </tbody>
            </table>
            <p><small>{this.state.result ? this.state.answer : '' }</small></p>
            <button className="btn" onClick={this.handleShuffle}>another Quizz</button>
            <button className="submitBtn btn btn-outline-primary" onClick={this.handleSubmit}>Submit</button>
          </div>
        </header>
      </div>
    );
  }
}

export default App;
