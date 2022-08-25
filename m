Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841EA5A16A2
	for <lists+live-patching@lfdr.de>; Thu, 25 Aug 2022 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiHYQ0c (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Aug 2022 12:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243069AbiHYQ0b (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Aug 2022 12:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15B67CA4
        for <live-patching@vger.kernel.org>; Thu, 25 Aug 2022 09:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661444788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBP2+G42OMoMwnqdV2vMK60zYr6xOaGHcldEWnYhFNg=;
        b=G3z/8zZuEA7w/iEz+cwnx3P5ggAG6YPEWYkr1HWkyxxA90AYC57DIehJXBbqI7PIDPzvB4
        CZrPWtiovkBxGgaKIP9zNfd89TUz8cQf0Ln/CO3maElBsjdeRVXVLt0oRp/bjQCueTx1pg
        FAmkVu/N4Gfa6j4dyGP2nlmyu/+kqQg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-hcK5s9-QP66fyxoxiwmuXA-1; Thu, 25 Aug 2022 12:26:27 -0400
X-MC-Unique: hcK5s9-QP66fyxoxiwmuXA-1
Received: by mail-qv1-f70.google.com with SMTP id db3-20020a056214170300b00496c0aabfc9so11223145qvb.16
        for <live-patching@vger.kernel.org>; Thu, 25 Aug 2022 09:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:from:references:cc:to
         :x-gm-message-state:from:to:cc;
        bh=QBP2+G42OMoMwnqdV2vMK60zYr6xOaGHcldEWnYhFNg=;
        b=GZexySQ4ca0+rkoRjJauWQXq8KuB5hdbWaoHNWPmykGjUlbiRIfLZqvttYXHRcNr5/
         B5SvJReRDsS8OOAtwuaLhkpFbUDHpSThHvSTQO/RLRymSCSLo7Cf6/r/74QkqCbIvaCN
         Cr2HZwsp/KlbBOZfunvWAp1TejZi9J54yqVeQNLW3rm+BASO1iByQFeWdr/Md6eAKlZ/
         6CnGyijRq4ln95pbHIvYuiefCzF2z9EIpeKk1ZQhGi+YdjvaIvqhse/eOOW3m0icUWjx
         9A8x0P4h2gM+9YOt+KY7hE1IabwOXEVoAbE84kXKzR9JJ7PRKdw4nUYurlwtyVcrmxwo
         O1VQ==
X-Gm-Message-State: ACgBeo02pvgcB7DZkuLM5EwwLpBZxi/fZcmJ7nWXDjpGlxBo1MURqmP6
        SNFxzUkUmnEqTLfBJDUbzKVCrpJobEgWwLkOyIuhZWi76CUkBNpC/Y54BXUmfUO6MwqxshLdhzF
        c7mFDuiOHHkRYX50AISPLUODXAQ==
X-Received: by 2002:a05:622a:1909:b0:344:9f41:9477 with SMTP id w9-20020a05622a190900b003449f419477mr4251542qtc.619.1661444787017;
        Thu, 25 Aug 2022 09:26:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR62RGiq2S68kTCuavDT7NSb7NgKOTzjHMBEZeS17J6JGsxz5uqWmWKqHiDKd7xSnfoU2KF8Fw==
X-Received: by 2002:a05:622a:1909:b0:344:9f41:9477 with SMTP id w9-20020a05622a190900b003449f419477mr4251521qtc.619.1661444786728;
        Thu, 25 Aug 2022 09:26:26 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id u4-20020a05620a454400b006bbe7ded98csm14674408qkp.112.2022.08.25.09.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 09:26:26 -0700 (PDT)
To:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com>
Date:   Thu, 25 Aug 2022 12:26:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220701194817.24655-5-mpdesouza@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
> The life of shadow variables is not completely trivial to maintain.
> They might be used by more livepatches and more livepatched objects.
> They should stay as long as there is any user.
> 
> In practice, it requires to implement reference counting in callbacks
> of all users. They should register all the user and remove the shadow
> variables only when there is no user left.
> 
> This patch hides the reference counting into the klp_shadow API.
> The counter is connected with the shadow variable @id. It requires
> an API to take and release the reference. The release function also
> calls the related dtor() when defined.
> 
> An easy solution would be to add some get_ref()/put_ref() API.
> But it would need to get called from pre()/post_un() callbacks.
> It might be easy to forget a callback and make it wrong.
> 
> A more safe approach is to associate the klp_shadow_type with
> klp_objects that use the shadow variables. The livepatch core
> code might then handle the reference counters on background.
> 
> The shadow variable type might then be added into a new @shadow_types
> member of struct klp_object. They will get then automatically registered
> and unregistered when the object is being livepatched. The registration
> increments the reference count. Unregistration decreases the reference
> count. All shadow variables of the given type are freed when the reference
> count reaches zero.
> 
> All klp_shadow_alloc/get/free functions also checks whether the requested
> type is registered. It will help to catch missing registration and might
> also help to catch eventual races.
> 

If I understand the patchset correctly, the last patch consolidated
id/ctor/dtor into klp_shadow_type structure, then this one formally
associates the new structure with a klp_object so that it bumps up /
down a simple reference count automatically.  That count is now checked
before calling the dtor/removal of any matching shadow variable.  So far
so good.

How does this play out for the following scenario:

- atomic replace livepatches, accumulative versions
- livepatch v1 : registers a klp_shadow_type (id=1), creates a few
shadow vars
- livepatch v2 : also uses klp_shadow_type (id=1) and creates a few
shadow vars

Since the first livepatch registered the klp_shadow_type, its ctor/dtor
pair will be used for all id=1 shadow variables, including those created
by the subsequent livepatches, right?


> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/livepatch.h                 |  21 ++++
>  kernel/livepatch/core.c                   |  39 +++++++
>  kernel/livepatch/core.h                   |   1 +
>  kernel/livepatch/shadow.c                 | 124 ++++++++++++++++++++++
>  kernel/livepatch/transition.c             |   4 +-
>  lib/livepatch/test_klp_shadow_vars.c      |  18 +++-
>  samples/livepatch/livepatch-shadow-fix1.c |   8 +-
>  samples/livepatch/livepatch-shadow-fix2.c |   9 +-
>  8 files changed, 214 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 79e7bf3b35f6..cb65de831684 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -100,11 +100,14 @@ struct klp_callbacks {
>  	bool post_unpatch_enabled;
>  };
>  
> +struct klp_shadow_type;
> +
>  /**
>   * struct klp_object - kernel object structure for live patching
>   * @name:	module name (or NULL for vmlinux)
>   * @funcs:	function entries for functions to be patched in the object
>   * @callbacks:	functions to be executed pre/post (un)patching
> + * @shadow_types: shadow variable types used by the livepatch for the klp_object
>   * @kobj:	kobject for sysfs resources
>   * @func_list:	dynamic list of the function entries
>   * @node:	list node for klp_patch obj_list
> @@ -118,6 +121,7 @@ struct klp_object {
>  	const char *name;
>  	struct klp_func *funcs;
>  	struct klp_callbacks callbacks;
> +	struct klp_shadow_type **shadow_types;
>  

Hmm.  The implementation of shadow_types inside klp_object might be
difficult to integrate into kpatch-build.  For kpatches, we do utilize
the kernel's shadow variable API directly, but at kpatch author time we
don't have any of klp_patch objects in hand -- those are generated by
template after the binary before/after comparison is completed.

My first thought is that kpatch-build might associate any shadow
variables in foo.c with its parent object (vmlinux, foo.ko, etc.),
however that may not always be 100% accurate.

In fact, we have occasionally used shadow variables with <id, 0> to
create one off variables not associated with specific code or data
structures, but rather the presence of livepatch.  This is (too) briefly
mentioned in "Other use-cases" section of the shadow variable Documentation.

-- 
Joe

