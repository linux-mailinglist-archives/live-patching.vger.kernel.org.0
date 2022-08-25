Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4978B5A14E2
	for <lists+live-patching@lfdr.de>; Thu, 25 Aug 2022 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiHYOyb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Aug 2022 10:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242311AbiHYOy2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Aug 2022 10:54:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28807B5A73
        for <live-patching@vger.kernel.org>; Thu, 25 Aug 2022 07:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661439262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NffFODJhrMzh8c1Bv1V696PyMNfWwfFj/gv4wrYigeI=;
        b=FixI4OEsbewhOAWwovbZTgEDg8rJcowqqU0wXU1WhKEa/zwuDqBbyr08/fFJYY2QHolwcQ
        ok2lN3uKqvgn/FJDJuSBAdZMImZgxgOoqJfHNS8G1hyggjR+mF8lyn13MLDDdGtqYhxl10
        TYwY8pGdBESxM7+DwCEnHIBjbs3Z4NM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-466-DQtj6FNBPF23zRYaJcBr3w-1; Thu, 25 Aug 2022 10:54:20 -0400
X-MC-Unique: DQtj6FNBPF23zRYaJcBr3w-1
Received: by mail-qv1-f70.google.com with SMTP id lx4-20020a0562145f0400b00496ecf45ac4so7315883qvb.7
        for <live-patching@vger.kernel.org>; Thu, 25 Aug 2022 07:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject
         :x-gm-message-state:from:to:cc;
        bh=NffFODJhrMzh8c1Bv1V696PyMNfWwfFj/gv4wrYigeI=;
        b=yhwW96pjJUNMGM//5Xz7NFEZskEPBO80udVF5M4SbM41AzAVuIhOd75YuyhOMJxj9G
         PJ1t4K+laz7fe2rswmVnRA7Yxfcl4KVB4HtoOohrsLumugVJsdM6H1gPOfizf4mubvno
         QV8xwHUPUq24bx/u2nSfA22LIMDf4wym0lUpXYdDFKWjkm3OnbBC/CR+rJ/kV5PXg6ng
         b9HFfUvP5iOFG1ywc8+xSpPSTKa6oqv25kLY4ChPTSeTpSQJflM7zTh9QYl+30w+crNL
         g8ocnVz8YDTtwSeQ0P4jaB8TNbsUlyA0FhBOxmHrBhgfaKR21+jpjmFWgxPPxcG8Pl/t
         zf7g==
X-Gm-Message-State: ACgBeo3+h+gBGp2WNAEBFHRQrndfM5vBdqYWB5msjtiB9sN8LpP5FDBK
        5OqJXIpM5dv0kAdokfYKFWzJ2uJcGU+HIUV1sO94jR7ywF/xcte7z0RG/TokVoqpLV+X5r/9rFz
        B9/eMRJy+efTru1XujXuR+Oq/1Q==
X-Received: by 2002:a05:6214:21cd:b0:496:db6f:1068 with SMTP id d13-20020a05621421cd00b00496db6f1068mr3872220qvh.45.1661439260262;
        Thu, 25 Aug 2022 07:54:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5kzfR0wODghBtTZulT0hP/6KkGo9rxZ0OJHY8T81Ni81idU8QBk70KMGPiQLi5cEajlNO3Eg==
X-Received: by 2002:a05:6214:21cd:b0:496:db6f:1068 with SMTP id d13-20020a05621421cd00b00496db6f1068mr3872203qvh.45.1661439259997;
        Thu, 25 Aug 2022 07:54:19 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id h16-20020a05620a401000b006a793bde241sm18189736qko.63.2022.08.25.07.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 07:54:19 -0700 (PDT)
Subject: Re: [PATCH 3/4] livepatch/shadow: Introduce klp_shadow_type structure
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-4-mpdesouza@suse.com>
 <a0daa94e-a66d-ad14-339c-ed08b3914469@redhat.com>
Message-ID: <2d00d226-9db2-7efd-903e-622e5698aaca@redhat.com>
Date:   Thu, 25 Aug 2022 10:54:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a0daa94e-a66d-ad14-339c-ed08b3914469@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/25/22 10:50 AM, Joe Lawrence wrote:
> On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
>> The shadow variable type will be used in klp_shadow_alloc/get/free
>> functions instead of id/ctor/dtor parameters. As a result, all callers
>> use the same callbacks consistently[*][**].
>>
>> The structure will be used in the next patch that will manage the
>> lifetime of shadow variables and execute garbage collection automatically.
>>
>> [*] From the user POV, it might have been easier to pass $id instead
>>     of pointer to struct klp_shadow_type.
>>
>>     The problem is that each livepatch registers its own struct
>>     klp_shadow_type and defines its own @ctor/@dtor callbacks. It would
>>     be unclear what callback should be used. They should be compatible.
>>
>>     This problem is gone when each livepatch explicitly uses its
>>     own struct klp_shadow_type pointing to its own callbacks.
>>
>> [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
>>     The message must be disabled when called via klp_shadow_free_all()
>>     because the ordering of freed variables is not well defined there.
>>     It has to be done using another hack after switching to
>>     klp_shadow_types.
>>
> 
> Is the ordering problem new to this patchset?  Shadow variables are
> still saved in klp_shadow_hash and I think the only change in this patch
> is that we need to compare through shadow_type and not id directly.  Or
> does patch 4/4 change behavior here?  Just curious, otherwise this patch
> is pretty straightforward.
> 
>> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
>> Signed-off-by: Petr Mladek <pmladek@suse.com>
>> ---
>>  include/linux/livepatch.h                     |  29 +++--
>>  kernel/livepatch/shadow.c                     | 103 ++++++++---------
>>  lib/livepatch/test_klp_shadow_vars.c          | 105 ++++++++++--------
>>  samples/livepatch/livepatch-shadow-fix1.c     |  18 ++-
>>  samples/livepatch/livepatch-shadow-fix2.c     |  27 +++--
>>  .../selftests/livepatch/test-shadow-vars.sh   |   2 +-
>>  6 files changed, 163 insertions(+), 121 deletions(-)
>>
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 293e29960c6e..79e7bf3b35f6 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -216,15 +216,26 @@ typedef int (*klp_shadow_ctor_t)(void *obj,
>>  				 void *ctor_data);
>>  typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
>>  
>> -void *klp_shadow_get(void *obj, unsigned long id);
>> -void *klp_shadow_alloc(void *obj, unsigned long id,
>> -		       size_t size, gfp_t gfp_flags,
>> -		       klp_shadow_ctor_t ctor, void *ctor_data);
>> -void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
>> -			      size_t size, gfp_t gfp_flags,
>> -			      klp_shadow_ctor_t ctor, void *ctor_data);
>> -void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
>> -void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
>> +/**
>> + * struct klp_shadow_type - shadow variable type used by the klp_object
>> + * @id:		shadow variable type indentifier
>> + * @ctor:	custom constructor to initialize the shadow data (optional)
>> + * @dtor:	custom callback that can be used to unregister the variable
>> + *		and/or free data that the shadow variable points to (optional)
>> + */
>> +struct klp_shadow_type {
>> +	unsigned long id;
>> +	klp_shadow_ctor_t ctor;
>> +	klp_shadow_dtor_t dtor;
>> +};
>> +
>> +void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
>> +void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
>> +		       size_t size, gfp_t gfp_flags, void *ctor_data);
>> +void *klp_shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
>> +			      size_t size, gfp_t gfp_flags, void *ctor_data);
>> +void klp_shadow_free(void *obj, struct klp_shadow_type *shadow_type);
>> +void klp_shadow_free_all(struct klp_shadow_type *shadow_type);
>>  
>>  struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
>>  struct klp_state *klp_get_prev_state(unsigned long id);
>> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
>> index 79b8646b1d4c..9dcbb626046e 100644
>> --- a/kernel/livepatch/shadow.c
>> +++ b/kernel/livepatch/shadow.c
>> @@ -63,24 +63,24 @@ struct klp_shadow {
>>   * klp_shadow_match() - verify a shadow variable matches given <obj, id>
>>   * @shadow:	shadow variable to match
>>   * @obj:	pointer to parent object
>> - * @id:		data identifier
>> + * @shadow_type: type of the wanted shadow variable
>>   *
>>   * Return: true if the shadow variable matches.
>>   */
>>  static inline bool klp_shadow_match(struct klp_shadow *shadow, void *obj,
>> -				unsigned long id)
>> +				struct klp_shadow_type *shadow_type)
>>  {
>> -	return shadow->obj == obj && shadow->id == id;
>> +	return shadow->obj == obj && shadow->id == shadow_type->id;
> 
> Not sure if I'm being paranoid, but is there any problem if the user
> registers two klp_shadow_types with the same id?  I can't find any
> obvious logic problems with that, but I don't think the API prevents
> this confusing possibility.
> 

Ah n/m, I think I see now that I'm reading patch 4/4, it's
klp_shadow_type_get_reg() is going to look for an existing
shadow_type_reg->id first.

-- 
Joe

