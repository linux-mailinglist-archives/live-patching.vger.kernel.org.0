Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554FE682352
	for <lists+live-patching@lfdr.de>; Tue, 31 Jan 2023 05:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjAaEhY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 30 Jan 2023 23:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjAaEgl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 30 Jan 2023 23:36:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A313BD89;
        Mon, 30 Jan 2023 20:36:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB525B81914;
        Tue, 31 Jan 2023 04:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D726C433EF;
        Tue, 31 Jan 2023 04:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675139782;
        bh=CLBqX+BUlH4wfB1ikkhG1DXuwqQ1HR2XR9twYN40fhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wih+AekNxMmghUFGZEhNRtJCR8fK8r8QexRrCmRFVImcdV7FTWieco0Bsc2L4Z5Rf
         BgLWMmSeBEPEscFrosyUqZydTogzNNZOnA47ZVxty82oYjakqFy05TKxi0yMeCwXFH
         rONcoV7qV+7jWxle+XdViid8CRmy3zYrYga1oObe7oObdTW2ecuN7KeVdObUw1Bxtx
         RYXhJ3o/G52DKOa3PGmKYlV4fACdXkAEpak9hzu/1ggCwaqLWsQKXXD98KrMtwntr4
         FAOVEOKGQu5e3re6fsDTbqS8K+txwQ92TGXl/4XZsX3MqMaApZOqwp6H5ecuRo+Akr
         1RnGkuA72tc5Q==
Date:   Mon, 30 Jan 2023 20:36:20 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com
Subject: Re: [PATCH v2 3/4] livepatch/shadow: Introduce klp_shadow_type
 structure
Message-ID: <20230131043620.6nnhqgqr4z55hxfr@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-4-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-4-mpdesouza@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 26, 2022 at 04:41:21PM -0300, Marcos Paulo de Souza wrote:
> +++ b/include/linux/livepatch.h
> @@ -216,15 +216,26 @@ typedef int (*klp_shadow_ctor_t)(void *obj,
>  				 void *ctor_data);
>  typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
>  
> -void *klp_shadow_get(void *obj, unsigned long id);
> -void *klp_shadow_alloc(void *obj, unsigned long id,
> -		       size_t size, gfp_t gfp_flags,
> -		       klp_shadow_ctor_t ctor, void *ctor_data);
> -void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
> -			      size_t size, gfp_t gfp_flags,
> -			      klp_shadow_ctor_t ctor, void *ctor_data);
> -void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
> -void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
> +/**
> + * struct klp_shadow_type - shadow variable type used by the klp_object
> + * @id:		shadow variable type indentifier

"identifier"

> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> index aba44dcc0a88..64e83853891d 100644
> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -63,24 +63,24 @@ struct klp_shadow {
>   * klp_shadow_match() - verify a shadow variable matches given <obj, id>

"matches given <obj, type>" ?

>   * @shadow:	shadow variable to match
>   * @obj:	pointer to parent object
> - * @id:		data identifier
> + * @shadow_type: type of the wanted shadow variable
>   *
>   * Return: true if the shadow variable matches.
>   */
>  static inline bool klp_shadow_match(struct klp_shadow *shadow, void *obj,
> -				unsigned long id)
> +				struct klp_shadow_type *shadow_type)
>  {
> -	return shadow->obj == obj && shadow->id == id;
> +	return shadow->obj == obj && shadow->id == shadow_type->id;

"shadow_type" is redundant, can we just call it "type"?

Same comment for all other instances of 'shadow_type' throughout the
patch.

> @@ -159,22 +157,25 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
>  	 * More complex setting can be done by @ctor function.  But it is
>  	 * called only when the buffer is really used (under klp_shadow_lock).
>  	 */
> -	new_shadow = kzalloc(size + sizeof(*new_shadow), gfp_flags);
> +	new_shadow = kzalloc(size + sizeof(struct klp_shadow), gfp_flags);

Unnecessary change?

-- 
Josh
