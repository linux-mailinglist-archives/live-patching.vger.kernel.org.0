Return-Path: <live-patching+bounces-2736-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCoAL+kN+2mbVQMAu9opvQ
	(envelope-from <live-patching+bounces-2736-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 11:46:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C12B4D8DAE
	for <lists+live-patching@lfdr.de>; Wed, 06 May 2026 11:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BA07303B7C6
	for <lists+live-patching@lfdr.de>; Wed,  6 May 2026 09:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E27E3E95AE;
	Wed,  6 May 2026 09:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZpkzYjla"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878C33E869A
	for <live-patching@vger.kernel.org>; Wed,  6 May 2026 09:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778060527; cv=none; b=jmaXmB/kzxSv7xNWYsN8uHZpcILuiRBl7KU/9yXjKPChjl6RjBTTE6hDYUYkDBoC8GY7vrRwmx0wfRSZAsDxH2crPvo1oq9mZmRNqxIkgSbf0lWD4yxAdIm/XkUq0Iu0GpxKq1B0oPZjTmS3fTmQuwZt5pb2oRrmXkZpxrDcobQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778060527; c=relaxed/simple;
	bh=Hg+SIX19oqvzp1xnbgSAkfk1zUKsaY8M5LRlQAzgZMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtaODWAVMHt5TLf+Z+gYpX6xbTY+EYAQFOXPOdbLkqF77pgZdjH+iq1FLaPTYCitFzejbJBm94pP/buj54RMyws0epDmRYnRw6MYYLIjc+zpauURryd2227ukd/+1GXA8tGUUC7VhQXWorAeVhziH9NbAYdmQyk0N8FfutVxzk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZpkzYjla; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso47601555e9.0
        for <live-patching@vger.kernel.org>; Wed, 06 May 2026 02:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778060524; x=1778665324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=68kE/kTM+aJeMH8hx0nsLFRRLp7aRIisp/tUk6XMa40=;
        b=ZpkzYjla+xW2dCo8W9lO3ZoWyRq7zfH93XQ9z39hTAJepQMRuMo4wevl03bdU4T0lA
         GmE89cKpwPmDbquzsHsCBj4aPr1VggdaT8cdnkTGcScfsjZzUZad2omkPR3EKTyc1Pmf
         cxDC2OhGyeJixmgywkyRm8/sLlCRxhV3HBxaGc5ycyGEvB+kFE10BsgAw8hRI8ZJH+6y
         Lop/E1GHPb7ZcK3wZE43epW9JPch2oMgKL3XvUwZKA7L3x7e1C5FPrjLiP6w+IijRdEu
         ubXHfIQDHmPg2hnSSSySBUCsf/c2MCnNAk5TyQwfGzCU19H6A79zzFkWTnnlLiuaIiPu
         7z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778060524; x=1778665324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=68kE/kTM+aJeMH8hx0nsLFRRLp7aRIisp/tUk6XMa40=;
        b=O+FUFNwu4ClxZKwOzikn2FumxQlKDpoUoj5gp2LyHUkpcigjT4X4PT3s55tr47Wu0l
         a1bSpbONMEFjMgRtBAbyifiOsm4dFxQVyCMeTm4XLONceNdXyLeXt3Nt2oyyBYawrjMs
         6z0FkZHvUFGOS/wYL7FPkYOIkkQ63WOfjjvZh0AM/u/xARQnZKKk5scH9a8+zemGhSeJ
         Nk0uYWtlfXemw1MMIWYtPovF5oLpdRHiJ4CcO5CZXX17p4DiPtCp1OHcowVuHCT98bal
         PB8HfEbbGBtB4ToI8Z5EF/i6QVWsXAQV8DhQmwvjNkWQQl/w9PFNMI8tbGYqExVk/CyR
         ACiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8OzAIGQNQeFcrmFs95Q+txFvMwu2kWdRr1mO6m2LLXSSmL3urLtsk8LNmv/06dIvJ5/s1b0hrsYujVESu6@vger.kernel.org
X-Gm-Message-State: AOJu0YyMFXgNSQdUxNCQ/5BDkK7oBhzfql4AYF9ulYYf7C8RnUxHo/qU
	GXGq2dVZ4QdRgz/Db3CLcUru5Zhl9E4YN5kSmnJrTfpICovplJxAKV45W/05Ni6R9Oc=
X-Gm-Gg: AeBDieswD3zZWlufMbpFV/D8GB880Rf1S00IEiS33QMMV2ex32yrxjbpBIc3ejBn2HJ
	sdldcJlR96W/U55RUzCnntv/JT2nOZd5sE9jFaUpo8bqbltKpy67Mw+pDfJu9cchk6TxFORtg2U
	JXIfUI+EjnB/hIoubgM72Lo33BaVcM7Ga/0lD/Ca4RrTcLlvjT3jJOSrYvcDTrfQkKEKRhD99W6
	R+JYIETSI/efpo9JhMR9k3qQs2n0xhsAQV7TUTWGFMLgLhQ/EN0i6fMaSRBjyMrkWMnJ2hbkPJo
	rDIcmD5bz9N9r2CAf2K5B0HXYCrWLpYcEIvBJoSBLj1OiU+lHEin4DwDYDSFTv7A1GnIYsj+Q9o
	RgBBG91u/8QjjMGnTNj/ugezkfkJd732xEHsWOU4auX/FmnYgTWHLoUpwgmvd0Ls+OFkW7+hcCT
	TZvFikCxc6iLOTKMJVSQl4mVP1iovVUf8wt1SDt5wuvR08LuJ36cDGkHc=
X-Received: by 2002:a05:600c:c094:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-48e51f45a0dmr31127285e9.23.1778060523891;
        Wed, 06 May 2026 02:42:03 -0700 (PDT)
Received: from [192.168.42.79] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53156c95sm15613255e9.33.2026.05.06.02.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 02:42:02 -0700 (PDT)
Message-ID: <a08d598b-8031-4882-a459-8a38c1e761ed@suse.com>
Date: Wed, 6 May 2026 11:42:01 +0200
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
 <28bb0f74-8721-4e53-ad89-87b2a78623b2@suse.com>
 <afsCpoGPasi-kBLb@pathway.suse.cz>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <afsCpoGPasi-kBLb@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C12B4D8DAE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_CC(0.00)[wp.pl,vger.kernel.org,google.com,kernel.org,atomlin.com,goodmis.org,jordanrome.com,redhat.com,suse.cz];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2736-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nano:email]

On 5/6/26 10:58 AM, Petr Mladek wrote:
> On Tue 2026-05-05 16:37:56, Petr Pavlu wrote:
>> On 5/5/26 2:24 PM, Petr Mladek wrote:
>>> On Fri 2026-03-27 12:00:05, Stanislaw Gruszka wrote:
>>>> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
>>>> over the entire symtab when resolving an address. The number of symbols
>>>> in module symtabs has grown over the years, largely due to additional
>>>> metadata in non-standard sections, making this lookup very slow.
>>>>
>>>> Improve this by separating function symbols during module load, placing
>>>> them at the beginning of the symtab, sorting them by address, and using
>>>> binary search when resolving addresses in module text.
>>>>
>>>> This also should improve times for linear symbol name lookups, as valid
>>>> function symbols are now located at the beginning of the symtab.
>>>>
>>>> The cost of sorting is small relative to module load time. In repeated
>>>> module load tests [1], depending on .config options, this change
>>>> increases load time between 2% and 4%. With cold caches, the difference
>>>> is not measurable, as memory access latency dominates.
>>>>
>>>> The sorting theoretically could be done in compile time, but much more
>>>> complicated as we would have to simulate kernel addresses resolution
>>>> for symbols, and then correct relocation entries. That would be risky
>>>> if get out of sync.
>>>>
>>>> The improvement can be observed when listing ftrace filter functions.
>>>>
>>>> Before:
>>>>
>>>> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
>>>> 74908
>>>>
>>>> real	0m1.315s
>>>> user	0m0.000s
>>>> sys	0m1.312s
>>>>
>>>> After:
>>>>
>>>> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
>>>> 74911
>>>>
>>>> real	0m0.167s
>>>> user	0m0.004s
>>>> sys	0m0.175s
>>>>
>>>> (there are three more symbols introduced by the patch)
>>>>
>>>> For livepatch modules, the symtab layout is preserved and the existing
>>>> linear search is used. For this case, it should be possible to keep
>>>> the original ELF symtab instead of copying it 1:1, but that is outside
>>>> the scope of this patch.
>>>
>>> What is the exact motivation for the special handling of livepatch modules,
>>> please?
>>>
>>> Honestly, I am always a bit lost in the various symbol tables. It is
>>> possile that I have got something wrong.
>>>
>>> Anyway, my understanding is that there are two aspects which are important
>>> for livepatches:
>>>
>>> 1. Livepatches need to preserve special symbols which are used to
>>>    relocate symbols which were local in the original code, see
>>>    Documentation/livepatch/module-elf-format.rst
>>>
>>>    IMHO, this is why layout_symtab() computes space for all core
>>>    symbols in livepatch modules and copies them in add_kallsyms().
>>>
>>>    The symtab is normally released when the module is loaded.
>>>    But livepatch modules make its own copy of the important
>>>    parts, see copy_module_elf().
>>>
>>>    IMHO, the sorting of function symbols vs other symbols does
>>>    not matter here. I believe that the special relocation
>>>    symbols are not affected by this.
>>
>> I'm not sure if I fully follow the conclusion in this point. My
>> understanding is that .klp.rela sections still refer to their special
>> symbols in the symbol table via Elf_Rela::r_info. If the symbol table is
>> filtered or reordered, these references will end up pointing to
>> incorrect symbols.
> 
> My understanding is that the relocations point to symbols which
> are found via the name of the entry. Let's take an example
> from Documentation/livepatch/module-elf-format.rst:
> 
>      73: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.vmlinux.snprintf,0
> 
> This symbol points to snprintf() function in vmlinux object.
> The address of this function is found via kallsyms, see
> klp_find_object_symbol().
> 
> IMHO, it does not matter if we shuffle this entry in the livepatch
> module because the real address is found via kallsyms().
> 
> Even the ordering of the entries in vmlinux is not important in
> _this particular case_ because the "sympos" is zero "0" in this case.
> It means that "snprintf" symbol name is unique in vmlinux.
> 
> The ordering of the symbols in "vmlinux" becomes important
> if the livepatch needs to access a symbol and there are more
> symbols of the same name. This is what I tried to describe
> below.
> 
> I hope that it makes some sense. As I said, I am not familiar
> with the elf format...

Ah, I misunderstood your original point. I agree that reshuffling the
symbol table in a livepatch module will not cause any issues with
binding .klp.sym.<objname>.<symname>,<sympos> symbol references to their
actual definitions in <objname>.

The problem still exists with the .klp.rela sections. They are regular
RELA sections in the sense that each ELF_R_SYM(Elf_Rela::r_info) value
is an index identifying a symbol in the symbol table. If the module
loader reshuffles or filters the original symbol table in any way, the
indexes in Elf_Rela::r_info would need to be adjusted accordingly.

-- 
Thanks,
Petr

