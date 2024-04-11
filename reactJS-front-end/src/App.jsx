import { useState, useEffect } from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import style from './App.module.css'

// Variable global para la página actual
let page = 1

export function App() {
  // Definición de múltiples estados con useState
  const [featuresData, setFeaturesData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [commentsData, setCommentsData] = useState(null)
  const [commentText, setCommentText] = useState('')
  const [commetId, setCommetId] = useState(null)
  const [commentAlertText, setCommentAlertText] = useState('')
  const [alerColor, setAlerColor] = useState('')
  const [magFilter, setMagFilter] = useState('')
  const [perPageFilter, setPerPageFilter] = useState(10)

  // Función para realizar la solicitud de datos
  const fetchData = async (pageParam) => {
    setFeaturesData(null)

    if (pageParam == 'next') {
      page++
    } else if (pageParam == 'prev') {
      page--
    }

    try {
      const response = await fetch(`http://127.0.0.1:3000/api/features?page=${page}&per_page=${perPageFilter}&filters[mag_type]=${magFilter}`);
      if (!response.ok) {
        throw new Error('Error al traer los datos');
      }
      const jsonData = await response.json();
      setFeaturesData(jsonData);


    } catch (error) {
      setError(error);
    } finally {
      setLoading(false);
    }
  };

  // useEffect para cargar los datos al inicio
  useEffect(() => {


    fetchData()
  }, []);

  // Función para obtener los comentarios de una característica
  const verComentarios = async (external_id) => {
    setCommentsData(null)
    await fetch(`http://127.0.0.1:3000/api/feature/${external_id}/comment`)
      .then((response) => {
        if (response.status == 200) {
          return response.json()
        }
        else if (response.status == 404) {
          setCommentsData('Este feature no tiene comentarios')
          throw Error(response.statusText)
        }
      })
      .then((data) => {
        setCommentsData(data)
      })
  }

  // Función para enviar un comentario
  const hacerUnComenatario = async () => {
    let textoSinEspacios = commentText
    textoSinEspacios = textoSinEspacios.replace(/^\s+|\s+$/gm, '')

    // Verifica si el comentario está vacío
    if (!textoSinEspacios.startsWith('')) {
      setCommentText('')
      setCommentAlertText('El comentario tiene que contener texto')
      setAlerColor('danger')
    }
    else {
      await fetch(`http://127.0.0.1:3000/api/features/${commetId}/comments`, {
        method: "POST",
        headers: { "Content-type": "application/json" },
        body: JSON.stringify({ body: textoSinEspacios })
      })
        .then((response) => {
          if (response.status == 201 || response.status == 200) {
            setCommentAlertText('comentario Creado!')
            setAlerColor('success')
            return response.json()
          }
          else {
            setCommentText('')
            setCommentAlertText('El comentario tiene que contener texto')
            setAlerColor('danger')
            throw Error(response.statusText)

          }
        })
      setCommentText('')
    }
  }


  return (

    <div className='back-ground'>
      <h1 className='text-center'>Filtros</h1>

      <div className=' row justify-content-center text-center'>
        {/*Asigno el filtro de seleccion de magnitud*/}
        <select className="form-select col-6 w-25" aria-label="Default select example" onChange={(e) => setMagFilter(e.target.value)}>
          <option value={''}>Todos los mag types</option>
          <option value={'md'} >MD</option>
          <option value={'ml'}>ML</option>
          <option value={'ms'}>MS</option>
          <option value={'mw'}>MW</option>
          <option value={'me'}>ME</option>
          <option value={'mi'}>MI</option>
          <option value={'mb'}>MB</option>
          <option value={'mg'}>MG</option>
        </select>

        {/*Asigno el filtro de seleccion de resultados por pagina*/}
        <select className="form-select col-6 w-25 " aria-label="Default select example" onChange={(e) => setPerPageFilter(e.target.value)}>
          <option value={10}>Filtrar por cantidad</option>
          <option value={25} >25</option>
          <option value={50}>50</option>
          <option value={100}>100</option>
          <option value={200}>200</option>
          <option value={400}>400</option>
          <option value={800}>800</option>
          <option value={1000}>1000</option>
        </select>

        {/*hago un request con las selecciones y retorno a la pagina 1*/}
        <button type="button" className="btn btn-primary col-1 mx-2" onClick={() => fetchData(page = 1)}>Filtrar</button>

        <div className="btn-group w-50 col-12 m-5" role="group" aria-label="Basic example">
          <button type="button" className="btn btn-secondary" onClick={() => fetchData('prev')} >Pagina anterior</button>
          <button type="button" className="btn btn-outline-primary">
            <strong> {page} de {featuresData == null ? "cargando" : featuresData.pagination.total}
            </strong></button>
          <button type="button" className="btn btn-secondary" onClick={() => fetchData('next')}>Siguiente pagina</button>
        </div>


      </div>


      <div className='d-flex p-4 row justify-content-center'>
        {

          featuresData == null ? <div className='spinner-border text-primary'></div> :

            featuresData.data.map((element, index) =>
              <div className={`${style.card} card col-4 m-3 text-center`} id={index} key={index} >
                <div className="card-header ">
                  <h5>ID </h5>
                  <h6>{element.id}</h6>
                  <h5>Type </h5>
                  <h6>{element.type}</h6>
                </div>
                <div className={`${style.cardBody}card-body`}>
                  <h5 className='pb-2'>Attributes</h5>
                  <h5>External ID</h5>
                  <p><strong>{element.attributes.external_id}</strong></p>
                  <h5>Magnitude</h5>
                  <p><strong>{element.attributes.magnitude}</strong></p>
                  <h5>Place</h5>
                  <p><strong>{element.attributes.place}</strong></p>
                  <h5>Time</h5>
                  <p><strong>{element.attributes.time}</strong></p>
                  <h5>Tsunami</h5>
                  <p><strong>{element.attributes.tsunami == true ? 'True' : 'False'}</strong></p>
                  <h5>Mag Type</h5>
                  <p><strong>{element.attributes.mag_type.toUpperCase()}</strong></p>
                  <h5>Title</h5>
                  <p><strong>{element.attributes.title}</strong></p>
                  <h5>Coordinates</h5>
                  <p><strong>longitude: {element.attributes.coordinates.longitude}</strong></p>
                  <p><strong>latitude: {element.attributes.coordinates.latitude}</strong></p>
                  <h5>Links</h5>
                  <p><strong>{element.links.external_url}</strong></p>

                  <div className='m-2'>
                    {/*Boton para lanzar el modal con el text box de hacer un comentario*/}
                    <button className="btn btn-primary col-4 mx-1" data-bs-toggle="modal" data-bs-target="#hacer-comentario" onClick={() => setCommetId(element.id, setCommentAlertText(''))}>
                      Hacer un comentario
                    </button>
                    {/*Boton para ver lanzar el modal y hacer el get de los comentarios*/}
                    <button type="button" className="col-4 btn btn-primary mx-1" data-bs-toggle="modal" data-bs-target='#ver-comentarios' onClick={() => verComentarios(element.id)}>
                      Ver Comentarios
                    </button>
                  </div>
                  {/*Modal para vizualizar los comentarios*/}
                  <div className="modal fade" id="ver-comentarios" data-bs-backdrop="static" data-bs-keyboard="false" tabIndex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                    <div className="modal-dialog">
                      <div className="modal-content">
                        <div className="modal-header">
                          <h1 className="modal-title fs-5" id="staticBackdropLabel">Comentarios</h1>
                          <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        {commentsData == null ? <div className="d-flex justify-content-center"><div className="spinner-border m-5" role="status"></div> </div> :
                          commentsData == "Este feature no tiene comentarios" ? <div className="alert alert-warning m-3 text-center" role="alert">
                            <b>{commentsData}</b></div> :
                            <div className="modal-body" >
                              {
                                commentsData.map((element, index) => <div className='my-1'>
                                  <div className="card" key={index}>
                                    <div className="card-body">

                                      <p>{element.body}</p>
                                    </div>
                                  </div>
                                </div>)
                              }
                            </div>
                        }
                        <div className="modal-footer">
                          <button type="button" className="btn btn-danger w-100" data-bs-dismiss="modal" >Close</button>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/*Modal con el text box para hacer el comentario*/}
                  <div className="modal fade" id="hacer-comentario" data-bs-backdrop="static" data-bs-keyboard="false" tabIndex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                    <div className="modal-dialog">
                      <div className="modal-content">
                        <div className="modal-header">
                          <h1 className="modal-title fs-5" id="staticBackdropLabel">Escribe tu comentario aqui!!</h1>
                          <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div className="modal-body">
                          {commentAlertText.length == 0 ? "" : <div className={`alert alert-${alerColor}`} role="alert">{commentAlertText}</div>}
                          <div className="input-group">
                            <textarea className="form-control" aria-label="With textarea" style={{ minHeight: '200px', resize: 'none' }} value={commentText} onChange={(e) => setCommentText(e.target.value)} >
                            </textarea>
                          </div>
                        </div>
                        <div className="modal-footer">
                          <button type="button" className="btn btn-secondary" data-bs-dismiss="modal" onClick={() => setCommentText('')}>Close</button>
                          <button type="button" className="btn btn-success" onClick={() => hacerUnComenatario()}>Enviar</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

      </div>

    </div>
  )
}
