Return-Path: <live-patching+bounces-2733-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mOZICz4C+ml1HAMAu9opvQ
	(envelope-from <live-patching+bounces-2733-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 16:44:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A3D4CFA33
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 16:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B085306A1A2
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 14:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DF53E92BD;
	Tue,  5 May 2026 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bfOCfQwx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F94036308F
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991881; cv=none; b=I8HVobQEc070OxgP24bJabdmxLfG//TlYblAFQOIZWvHwv99Mgi2FyCHA+CfhQ7ThHMfSxccivyPbf03c3agLYMOZokflwhiPZpZCJuJv0ttqgtLuT4LSqwOwvTRcBSoI6umU9z71HSdzylWi1eYDg7xjWhJkbpwqe+VbQXAlC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991881; c=relaxed/simple;
	bh=JvUqTfqiAW9yC35/8X+aOZcYzssa6BCdLInlTa1/lkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oADHQADUv7RL7QVczy0VXTBXbPhHuHR7SKUOVwyS07ecuxHAg3PMj2M4sgQlQ2HuXPCoAJ2xhZepib8NGEUrdt9QMA8lH3ISSRoIM1QOxuTL6WFsyI6IyKrNPZcLp+5Ifpr5zBvJ6PJsc7Rfb8mbhjNk693kmo5XG6P3yLlaU4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bfOCfQwx; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b150559bso36852865e9.1
        for <live-patching@vger.kernel.org>; Tue, 05 May 2026 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777991879; x=1778596679; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rW/yHyxsN9QI7AveMhZMYM5ISMvZ0yqJBxdD/EhC5LQ=;
        b=bfOCfQwxrawu82lUm1DRP/xOV/wBNJhWMJG6XVRH3eyQ8GucyHVVfJoXgIrrCTxt4l
         A4WUC3p14+oyf0DBh8Q2uB8ZuK5O6D74Eg/k+BYtaQkG2f/nyMjmkhtup6UcM6LoPnmd
         PK7ieHiGSTakBdqqZfr5yFNLdwIXU2oupKKg0y1uVGrSajVabDHBv56QJXPKyMMh6sHh
         kSKTQSh398izPQkFWhRhHnH6D0aYnO+PSCXZbwEi9AhJs8GJkb/W0SH0RO1h7yLj+Ezw
         Qe1VTjq1CsABEKRrKDQqU1GUuHYVCBYJr8ZrXRn7tNJITOr5OzFRNBev9pYcxc+W9+q3
         XL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777991879; x=1778596679;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rW/yHyxsN9QI7AveMhZMYM5ISMvZ0yqJBxdD/EhC5LQ=;
        b=RtZJqMMeXkbnjUsHCRz/yQ4OqsvHi+BOWsJF+SevstUmTuD7y4VZEHhfxtCZ5+WFuh
         uzgm6KNaO1JZ5Qd57yF9BqlBedzgZA3HHQFJ7m9ZaNnjpWnNuKlSSAT4P6FudGkX2Ebl
         jpi3dBbJvitCLVFIsCAmoJu5rKD2XFMFqmPO1+rTECn213vI+XeM27yG9wgRIWpTjBDe
         kz8nG3uwj/uZJ7hwrWalOAJoWNUmEuq1lvwqYMon6ncwsWU+b0yVwr/tKTR9qIAXceef
         beTYHh+KkThWYG0uJ/wZOvmI2v/CuVeYwRfdmbs7g8fgloT16+MVjDCd6MI/5PdHfH5b
         wUzQ==
X-Forwarded-Encrypted: i=1; AFNElJ+YvaQJHJk+NMDe/QYaecTGOlZsKBkQJ3JHzVirnTaINTiOfRAGD0vBMTa+Ry3kZv3PA1TbuLwXhErvV40a@vger.kernel.org
X-Gm-Message-State: AOJu0YyCee3eCrEOIeTPzQ1OConSvLyB1RB8Y516FeOPBWS0i43HSVe7
	F9/mLT18XUwsOJvk+Z5ds5CgflIFBfeA7W9Rshc9OTr/mTqMWfyBnHmg8c8sQc1HctQ=
X-Gm-Gg: AeBDieubTa6+YDMjWcPS77jDmGarrAbclnuWfO7c1+zZZagSeso5vYE5axU+FqIzvBy
	R2zMYyiJLM8RZ05eSfNncB9IVUtFRe0+wfZMSUSBCqnW6YJ9GcItpn53Pp/601lzFGQ8VMdf4ps
	ASdzbe1RvNMeR3vxFhP2T2T+L9yOdiTbax7TejAusfWW6J3cutGFSbSdlpEmzBqqzeC/scMj2NH
	DxhZqC25kXwYz/LV1U55yLKngRCS2v9Ir6TBOGrYHuDu4D0rlt+ADvvOE5xPMSSPjQa8IHhNecW
	0FRu818K/pUkP4oKRx0jNu+UIIwWV/FL49srVagvAIYYa5djwzuFB3w91XzOYS3zvlElLAzjj+V
	hT9JBLAaZUhDdBFAFtsVuPi5v++1Hym11pWJeH/2je8uyQ25094HGZDaYiiRGgomJNGO/HxE+XK
	dkxuAld+XIceiNc07oX+fHd9tLig3G6pyH2AEKQyALyEA3z5Fftg1B9TfKXeZnRTtEhQlmJerP1
	kaQ5sqCeq1mwGQLnHaM/6zJxvI8hLsXhsK5VBn+6s1zN98p37rJMIPYUFHc5npcKzq3T7X4XHr1
	kzNOOPz0wxtsXVo=
X-Received: by 2002:a05:600c:4e43:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-48a98638227mr256258935e9.12.1777991878651;
        Tue, 05 May 2026 07:37:58 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8ebb2fa5sm309081525e9.12.2026.05.05.07.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 07:37:58 -0700 (PDT)
Message-ID: <28bb0f74-8721-4e53-ad89-87b2a78623b2@suse.com>
Date: Tue, 5 May 2026 16:37:56 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] module/kallsyms: sort function symbols and use
 binary search
To: Petr Mladek <pmladek@suse.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, linux-modules@vger.kernel.org,
 Sami Tolvanen <samitolvanen@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Daniel Gomez <da.gomez@kernel.org>, Aaron Tomlin <atomlin@atomlin.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jordan Rome <linux@jordanrome.com>,
 Viktor Malik <vmalik@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>
References: <20260327110005.16499-1-stf_xl@wp.pl>
 <20260327110005.16499-2-stf_xl@wp.pl> <afnhidn7K7dZ_cPh@pathway.suse.cz>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <afnhidn7K7dZ_cPh@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 93A3D4CFA33
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_CC(0.00)[wp.pl,vger.kernel.org,google.com,kernel.org,atomlin.com,goodmis.org,jordanrome.com,redhat.com,suse.cz];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2733-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nano:email]

On 5/5/26 2:24 PM, Petr Mladek wrote:
> On Fri 2026-03-27 12:00:05, Stanislaw Gruszka wrote:
>> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
>> over the entire symtab when resolving an address. The number of symbols
>> in module symtabs has grown over the years, largely due to additional
>> metadata in non-standard sections, making this lookup very slow.
>>
>> Improve this by separating function symbols during module load, placing
>> them at the beginning of the symtab, sorting them by address, and using
>> binary search when resolving addresses in module text.
>>
>> This also should improve times for linear symbol name lookups, as valid
>> function symbols are now located at the beginning of the symtab.
>>
>> The cost of sorting is small relative to module load time. In repeated
>> module load tests [1], depending on .config options, this change
>> increases load time between 2% and 4%. With cold caches, the difference
>> is not measurable, as memory access latency dominates.
>>
>> The sorting theoretically could be done in compile time, but much more
>> complicated as we would have to simulate kernel addresses resolution
>> for symbols, and then correct relocation entries. That would be risky
>> if get out of sync.
>>
>> The improvement can be observed when listing ftrace filter functions.
>>
>> Before:
>>
>> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
>> 74908
>>
>> real	0m1.315s
>> user	0m0.000s
>> sys	0m1.312s
>>
>> After:
>>
>> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
>> 74911
>>
>> real	0m0.167s
>> user	0m0.004s
>> sys	0m0.175s
>>
>> (there are three more symbols introduced by the patch)
>>
>> For livepatch modules, the symtab layout is preserved and the existing
>> linear search is used. For this case, it should be possible to keep
>> the original ELF symtab instead of copying it 1:1, but that is outside
>> the scope of this patch.
> 
> What is the exact motivation for the special handling of livepatch modules,
> please?
> 
> Honestly, I am always a bit lost in the various symbol tables. It is
> possile that I have got something wrong.
> 
> Anyway, my understanding is that there are two aspects which are important
> for livepatches:
> 
> 1. Livepatches need to preserve special symbols which are used to
>    relocate symbols which were local in the original code, see
>    Documentation/livepatch/module-elf-format.rst
> 
>    IMHO, this is why layout_symtab() computes space for all core
>    symbols in livepatch modules and copies them in add_kallsyms().
> 
>    The symtab is normally released when the module is loaded.
>    But livepatch modules make its own copy of the important
>    parts, see copy_module_elf().
> 
>    IMHO, the sorting of function symbols vs other symbols does
>    not matter here. I believe that the special relocation
>    symbols are not affected by this.

I'm not sure if I fully follow the conclusion in this point. My
understanding is that .klp.rela sections still refer to their special
symbols in the symbol table via Elf_Rela::r_info. If the symbol table is
filtered or reordered, these references will end up pointing to
incorrect symbols.

This is also described in Documentation/livepatch/module-elf-format.rst,
section "4.1 A livepatch module's symbol table".

> 
> 
> 2. Livepatches _rely on the sorting_ of symbols in the module.
>    The special relocation symbols might define a symbol position,
>    see
> 
> 	.klp.sym.objname.symbol_name,sympos
> 
>    in the documentation. It defines the position of the symbol
>    when there are more symbols of the same name, see
>    klp_match_callback() in kernel/livepatch/core.c.
> 
>    I am afraid that _this patch might break_ this when it moves
>    function symbols before non-funciton ones. I guess that
>    the symbols of the same name will not longer be groupped.

I see. So if the module loader sorts the symbol table in a regular
module and a livepatch module exists for that module, the livepatch may
no longer function correctly. This means that the loader cannot even
reorder the symbol table in regular modules.

-- 
Thanks,
Petr

