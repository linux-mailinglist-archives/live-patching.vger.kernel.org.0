Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E5767A39E
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 21:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjAXUJZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 15:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjAXUJY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 15:09:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3056348A05
        for <live-patching@vger.kernel.org>; Tue, 24 Jan 2023 12:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674590915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZlHrisrjivNag8krExh7n8GmeapkJNDFL8v/PEUtvw=;
        b=ZfuncHoRHxJUt6mfsmRLQUXcwuWtWkhXvd5m5o1MVhVJJzl35crGwDR715QGO/9gIzRFWK
        jynnpXp+Ju5yAoL0ycyWamoiKfVfEPpOTqN+OlyOQACnHg187X/qaw/EQG4/dkfdCiltgs
        2mAcoAk+1rnG/5luQERnSvvrrXpd33w=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-QPPqUZP3ODmzYa1YlrXHog-1; Tue, 24 Jan 2023 15:08:29 -0500
X-MC-Unique: QPPqUZP3ODmzYa1YlrXHog-1
Received: by mail-qt1-f198.google.com with SMTP id c18-20020ac84e12000000b003b5d38f1d29so6494515qtw.0
        for <live-patching@vger.kernel.org>; Tue, 24 Jan 2023 12:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZlHrisrjivNag8krExh7n8GmeapkJNDFL8v/PEUtvw=;
        b=S7G8HHr1J49fcsPfUJMuI+9eZTqEuQxD0p33isRw3tsCYn/RJPsbybODppZOOHi7F4
         ggPcEppP+28Xgxy7pUSBJB5CO1qyQMxrPtYRY1wzFYtubuUGI/fx0Z49gzALXyDZyahx
         RyQLmbdj+mpJcLYalyUX1nh0UKWzxbfO7wnQ+Jdqf3C5L+uiRK2cAZWsV8UWnt1MIQBv
         iWB38yMM9IqSrqOl1+1yHuba7RqEDDj/q66A8XKqDUKjl6bBClqWGmppUu9qih2dPKht
         wRShvn0lyN/sZtXlvCsPnlPwpzLEp4Tx4vQNemO1x4VaCf1jJXv17JSsQ9Ne1grrf8YR
         X/Xw==
X-Gm-Message-State: AFqh2krM45b7YjIg2c6fDfm4QLxkHsYHu/grQYIKBPQESBtspicW9Gsk
        8vhjJodJUylAk6MerrKWHNLTA/uETMAunuaIuJVPVwwRVzSmYZQda/rEk3A1VydpTm8G8JI9pQx
        sznt7R0AvvG9SB7M7PpAssXq4fQ==
X-Received: by 2002:a05:6214:5d82:b0:534:a801:1131 with SMTP id mf2-20020a0562145d8200b00534a8011131mr45882662qvb.43.1674590909106;
        Tue, 24 Jan 2023 12:08:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuIULrSN5831DcR2bFIY1bRoKCemMhbW8/t5enh1wumovBzWa4Uzgv60OO1MWPaYERPIBafqQ==
X-Received: by 2002:a05:6214:5d82:b0:534:a801:1131 with SMTP id mf2-20020a0562145d8200b00534a8011131mr45882626qvb.43.1674590908766;
        Tue, 24 Jan 2023 12:08:28 -0800 (PST)
Received: from [192.168.1.16] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id 72-20020a370a4b000000b006fcc3858044sm2018287qkk.86.2023.01.24.12.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 12:08:28 -0800 (PST)
Message-ID: <57fa3069-8e7e-d204-4c78-05432156f044@redhat.com>
Date:   Tue, 24 Jan 2023 15:08:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Song Liu <song@kernel.org>
References: <20230118204728.1876249-1-song@kernel.org>
 <20230118220812.dvztwhlmliypefha@treble>
 <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com>
 <20230120064215.cdyfbjlas5noxam6@treble>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20230120064215.cdyfbjlas5noxam6@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/20/23 01:42, Josh Poimboeuf wrote:
> On Thu, Jan 19, 2023 at 11:06:35AM -0800, Song Liu wrote:
>> On Wed, Jan 18, 2023 at 2:08 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>>
>>> On Wed, Jan 18, 2023 at 12:47:28PM -0800, Song Liu wrote:
>>>> From: Miroslav Benes <mbenes@suse.cz>
>>>>
>>>> Josh reported a bug:
>>>>
>>>>   When the object to be patched is a module, and that module is
>>>>   rmmod'ed and reloaded, it fails to load with:
>>>>
>>>>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>>>
>>>>   The livepatch module has a relocation which references a symbol
>>>>   in the _previous_ loading of nfsd. When apply_relocate_add()
>>>>   tries to replace the old relocation with a new one, it sees that
>>>>   the previous one is nonzero and it errors out.
>>>>
>>>>   On ppc64le, we have a similar issue:
>>>>
>>>>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>>
>>> Shouldn't there also be a fix for this powerpc issue?
>>
>> There was a working version, but it was not very clean. We couldn't agree
>> on the path forward for powerpc, so we are hoping to ship the fix to x86 (and
>> s390?) first [1].
> 
> Sorry for coming in late, I was on leave so I missed a lot of the
> discussions on previous versions.  The decision to leave powerpc broken
> wasn't clear from reading the commit message.  The bug is mentioned, and
> the fix is implied, but surprisingly there's no fix.
> 
> I agree that the powerpc fix should be in a separate patch, but I still
> don't feel comfortable merging the x86 fix without the corresponding
> powerpc fix.
> 
> powerpc is a major arch and not a second-class citizen.  If we don't fix
> it now then it'll probably never get fixed until it blows up in the real
> world.
> 
> For powerpc, instead of clearing, how about just "fixing" the warning
> site, something like so (untested)?
> 
> 
> diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
> index 1096d6b3a62c..1a12463ba674 100644
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -499,9 +499,11 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
>  
>  /* We expect a noop next: if it is, replace it with instruction to
>     restore r2. */
> -static int restore_r2(const char *name, u32 *instruction, struct module *me)
> +static int restore_r2(const char *name, u32 *instruction, struct module *me,
> +		      bool klp_sym)
>  {
>  	u32 *prev_insn = instruction - 1;
> +	u32 insn_val = *instruction;
>  
>  	if (is_mprofile_ftrace_call(name))
>  		return 1;
> @@ -514,9 +516,18 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
>  	if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
>  		return 1;
>  
> -	if (*instruction != PPC_RAW_NOP()) {
> +	/*
> +	 * For a livepatch relocation, the restore r2 instruction might have
> +	 * been previously written if the relocation references a symbol in a
> +	 * module which was unloaded and is now being reloaded.  In that case,
> +	 * skip the warning and instruction write.
> +	 */
> +	if (klp_sym && insn_val == PPC_INST_LD_TOC)
> +		return 0;

Hi Josh,

Nit: shouldn't this return 1?

And if you're willing to entertain a small refactor, wouldn't
restore_r2() be clearer if it returned -ESOMETHING on error?

Maybe converting to a boolean could work, but then I'd suggest a name
that clearly implies success/fail given true/false return.  Maybe
replace_nop_with_ld_toc() or replace_nop_to_restore_r2() ... still
-ESOMETHING is more intuitive to me as there are cases like this where
the function safely returns w/o replacing anything.

> +
> +	if (insn_val != PPC_RAW_NOP()) {
>  		pr_err("%s: Expected nop after call, got %08x at %pS\n",
> -			me->name, *instruction, instruction);
> +			me->name, insn_val, instruction);
>  		return 0;
>  	}
>  
> @@ -649,7 +660,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  				if (!value)
>  					return -ENOENT;
>  				if (!restore_r2(strtab + sym->st_name,
> -							(u32 *)location + 1, me))
> +						(u32 *)location + 1, me,
> +						sym->st_shndx == SHN_LIVEPATCH))
>  					return -ENOEXEC;
>  			} else
>  				value += local_entry_offset(sym);
> 

klp-convert-tree tests* ran OK with this patch (with the nit fixed) on
top of Song's v10.  LMK if you want me to push a branch with some or all
of these patches for further testing.

* I removed the tests that check for relocation clearing, only tested
module reloading

-- 
Joe

