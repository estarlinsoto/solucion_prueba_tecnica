class CommentsController < ApplicationController
    # POST /api/features/:feature_id/comments
    def create
      # Busco el id en la tabla earthquakes
      earthquake = Earthquake.find_by(id: params[:id])
      comment = Comments.new
      if earthquake.present?
        # Crear un nuevo comentario asociado al id del feature encontrado
        comment_data = JSON.parse(request.body.read)
        # Confirmo que el body no este vacio y contenga la key body
        if comment_data.key?("body") && !comment_data["body"].empty?
          
          comment.body = comment_data["body"] 
          comment.feacture_id = earthquake["id"]     

            if comment.save
              render json: comment, status: :created
            else
              render json: comment.errors, status: :unprocessable_entity
            end
          else #Retorna errores comunicando el error
            render json: { error: 'El cuerpo del comentario no puede estar vacío'}, status: :unprocessable_entity
          end
        else
          render json: { error: 'No se encontró ningún terremoto con el id proporcionado' }, status: :not_found
        end
      end

    #/api/features/:feature_id/comments  (GET)
    def show
    
        internal_id = params[:internal_id] #Obtiene el internal_id desde la url
        comment = Comments.where(feacture_id: internal_id) #Retorna una un objeto con los ids que coincidan con el obtenido
        if comment.present?   
        render json: comment  #Retorno el objeto
        else
        render json: {error: 'Este feature no tiene comentarios'}, status: :not_found #En caso de no tener comentarios asociados 
    end
end
    def comment_params
      params.require(:comment).permit(:body)
    end
  end

