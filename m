Return-Path: <live-patching+bounces-1077-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96231A20892
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2025 11:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE53C1884E74
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2025 10:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A10319D8A8;
	Tue, 28 Jan 2025 10:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U4paw1zD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E35619D065
	for <live-patching@vger.kernel.org>; Tue, 28 Jan 2025 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738060303; cv=none; b=k6uB/XUtmfDqdrwPlyFz2UmkrJPbCkkyhMR036Yd7WrbusUqwXfFc1bpC8DS3tR88U9XOCX7DAwP57/pHQrbnGZoKWmsLK+shVXjpBbrxuzVGjgMIHmXhhMmu+I/NpXJ0giuZ3SZNBVbLpP1EMcerO5pDorq+j2XUNOb8akNVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738060303; c=relaxed/simple;
	bh=NagYAn2TrqtC5b5RwfDanYg+3MCbHeG3S0GDa3m3CQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nt2jv80230PvP1xaUYp8QB19Nv+1y8I8SkPztzGh1sQNDa0d3V99y3/qnJN3i/DXK3o6+F/AWWglIZwUz7a2+pv4cY8tw7jpWeFT3qxm+dbBnbL3YWvQ/8V29FnqeF628RYVuTMochVVdZToPb8s8p3b6KfqeGfB8DpKFCdT6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U4paw1zD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43618283dedso57632935e9.3
        for <live-patching@vger.kernel.org>; Tue, 28 Jan 2025 02:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738060298; x=1738665098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2XyAQrOTcI19ilumWSMw1hLrZQh31wPEOX9kHRV/Kjk=;
        b=U4paw1zD7zZ0EQCavCRc+K4qb1TkN59e/bubDOIcft/E9ttjtgYKhfOvOvV4VAMzuh
         fYhqXIs+Ula0utsFTmsAs/54YNeZKJ+ik4WteQ9mhJUZU3hNJgPzkhscdspu0Ci1gZWw
         qm74QuMeUTn1BKz3sppaNQHaA2kiZi9E1X8CNwUHLB1+wnPUCRGYvXO0lBas438yxvtl
         SuUcoyTZ89rKq0yhAsD9SZy3E8/ic64RHuNJCj5SX8ZKlgYMSDjxXEOu6os5RNd5IYSY
         bmhIHPFNUQCUZozfqk9+mYANoUoO7xn8gQ91h4KTqb2NgcxuHpX0eHNuBXRIunYvWERn
         dJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738060298; x=1738665098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XyAQrOTcI19ilumWSMw1hLrZQh31wPEOX9kHRV/Kjk=;
        b=q964zUDQ7SheVhZ8mGHPMmXsQkiIxoGuxa4PKNe6NugYq7924pBCX71/tdCWRUjffb
         IQBNZcD4O0cu1eJPLSbH2ZmHLCd0+6KmDON5cku652mgzUp/U/NcpGsc02NhOcgAK8FX
         XY4ppGohpuabs8izcYkN6oqZJQt5X1icOmwzVSmvLr87HMi99uHS/mmZD967DYjF6f++
         t40TJUWgaFJf/X1E3gdXLiYWSOGpp2DU8hS7p5/SrIHPSK2z6HGwlIseFoID1JOwrgHv
         wBl/IqzwrErsDb2hTN2mFJijGY3ne4KupBkJt27FeveLMlWG1m6a5Fjbe/S+si97UWX4
         eHaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV42aywWYVq463NX2zY6rEzUyc2ZOlky4QZsM+eXN34Tk9vakdTk7y/+tjn8Tn8tkWQ8JwCX4+GYF8vOgLh@vger.kernel.org
X-Gm-Message-State: AOJu0YwJd93sJURSUBKqNKmtIQ+vcJFLecW9dRj+iwBedLS0RlFdOe1v
	qIrChil6kFU5StVK6mxHpbryM3cAjY1G+OMRNqbd1oX6IWWxnwKh3rxKBzi1SJY=
X-Gm-Gg: ASbGncs2YldMfTjt5tgHr1z3RthS1pscNxDXFF/bDbD3sl/1kAUyBNpwIGCmC9I6tQz
	89VLPI94N0VczLN+aW2lSD+6RkXL6Y/qLzTkoOytB6cf9WRJiqLhs5c9dZrL10VZ3jlSnD0GHIE
	62NqxxBWu8d/SErbctwDY39K75iN75aZbSS5SmGluWh7IEaE4rBSjaDh30xWhE9ItVmuDUZb2af
	8DTkUs08jGPEqHMftxK6NiH4Ie5KQPljsTxFao51oPO4zJz7iUcHK5rasNcS63vlpkLB7rjceoi
	K6kX2jD0MgdZ1oYKPJo=
X-Google-Smtp-Source: AGHT+IF66ZZk/rhZtGcWoNDXw91fpPKUDEMFBtm8dpseiNoX9eGm2cyqqMp6iJGiup5xykF6TH0wXg==
X-Received: by 2002:a05:6000:1788:b0:382:3c7b:9ae with SMTP id ffacd0b85a97d-38bf56633damr43631218f8f.16.1738060298374;
        Tue, 28 Jan 2025 02:31:38 -0800 (PST)
Received: from [10.100.51.161] ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a188d5dsm14110246f8f.55.2025.01.28.02.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 02:31:38 -0800 (PST)
Message-ID: <099b8e0b-2c64-482f-8c22-32afc5b21beb@suse.com>
Date: Tue, 28 Jan 2025 11:31:36 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] module: switch to execmem API for remapping as RW
 and restoring ROX
To: Mike Rapoport <rppt@kernel.org>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Borislav Petkov <bp@alien8.de>, Brendan Higgins <brendan.higgins@linux.dev>,
 Daniel Gomez <da.gomez@samsung.com>, Daniel Thompson <danielt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Gow <davidgow@google.com>,
 Douglas Anderson <dianders@chromium.org>, Ingo Molnar <mingo@redhat.com>,
 Jason Wessel <jason.wessel@windriver.com>, Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Petr Mladek <pmladek@suse.com>, Rae Moar <rmoar@google.com>,
 Richard Weinberger <richard@nod.at>, Sami Tolvanen
 <samitolvanen@google.com>, Shuah Khan <shuah@kernel.org>,
 Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Gleixner <tglx@linutronix.de>, kgdb-bugreport@lists.sourceforge.net,
 kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, live-patching@vger.kernel.org
References: <20250126074733.1384926-1-rppt@kernel.org>
 <20250126074733.1384926-7-rppt@kernel.org>
 <021665c5-b017-415f-ad2b-0131dcc81068@suse.com> <Z5iq2GJKIdlB9APM@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Z5iq2GJKIdlB9APM@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/28/25 11:00, Mike Rapoport wrote:
> On Mon, Jan 27, 2025 at 01:50:31PM +0100, Petr Pavlu wrote:
>> On 1/26/25 08:47, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> Instead of using writable copy for module text sections, temporarily remap
>>> the memory allocated from execmem's ROX cache as writable and restore its
>>> ROX permissions after the module is formed.
>>>
>>> This will allow removing nasty games with writable copy in alternatives
>>> patching on x86.
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>
>> [...]
>>
>>> +static void module_memory_restore_rox(struct module *mod)
>>> +{
>>> +	for_class_mod_mem_type(type, text) {
>>> +		struct module_memory *mem = &mod->mem[type];
>>> +
>>> +		if (mem->is_rox)
>>> +			execmem_restore_rox(mem->base, mem->size);
>>> +	}
>>> +}
>>> +
>>
>> Can the execmem_restore_rox() call here fail? I realize that there isn't
>> much that the module loader can do if that happens, but should it be
>> perhaps logged as a warning?
> 
> It won't fail at this point. set_memory APIs may fail if they need to split
> a large page and could not allocate a new page table, but here all the
> splits were already done at module_memory_alloc() time.

Ok, thanks for the explanation.

Acked-by: Petr Pavlu <petr.pavlu@suse.com>

-- Petr

