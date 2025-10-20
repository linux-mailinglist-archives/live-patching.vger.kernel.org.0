Return-Path: <live-patching+bounces-1772-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44520BF2DD4
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 20:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D2A423467
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 18:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB13027B4E8;
	Mon, 20 Oct 2025 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZPpfwZc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA423BCF5
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760983704; cv=none; b=c8wj3aIg53jD4mpa0NYju2G8vx62aFLF88Cj9ami8yrruMLiPKbb+/S/f0GYwpr5sgfKviRYQSzQITcDKGBEDzHQxzUvnEAVggUyJ14hfWBTD5pTk78fio8SzBq/mA17ePBcZTIrOlDr0YmhdZlXl84m2KAn04qd6IJCnJ/9c/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760983704; c=relaxed/simple;
	bh=OCIcPYbIo0M7URSy3N3xFA27e5zDTVMOf2eGtCxqTvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrYgxVhamNZCePWtc2u8UCrSv2b4zDughiwnWZzZB7ZfkiRBhqszG26C+9sw0FYm07kVHrNvZhsGBl9hzEV23AvbCvSwiVhqlT47RDYZSCGiDmitSTuUbqkgjZqqfdGyt8UgJIgch6hEmNSzz73w1eLxclWo7YEJabGexQRKV+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZPpfwZc; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3e9d633b78so170028066b.1
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760983701; x=1761588501; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4Q2OXtz5WWKrpfISo8iGefWj+LEQC/IYNXPaBkbCI=;
        b=mZPpfwZcXoF8EiLZ9UOWRZR98Orh6GXhWs0FInCrAOR530BCc9+jB0v6YvAOmLd7Ri
         swHbGc8ur9w+iySYXCZ2m4LoNqsmwMS2E0zMqRbJGX+PeCSREfXXQFUPgWd9V9xSSTuG
         6iDUPHNKsIvn6kT8v5NbyOLrTJCoMkxDMiYbV8bdobMmb95bPnjeTYSlK0kV+FZ32GMt
         QJ6C4sWSZP+VS74c1BK2/lo0mfZhI1oBR2OUOxNlBS3WTW7PRoF1D7PU63FA+z/aZZ4e
         T0vDQDyyCZNfKy6JHlYL8r+x27wAfyckx6WeX4yyWDCxG22o9Ng3QyqFwQ43XS+gBWzO
         n9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760983701; x=1761588501;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4Q2OXtz5WWKrpfISo8iGefWj+LEQC/IYNXPaBkbCI=;
        b=hLSc7XajzuzvYL/1axhLmn1pn8UAbW+nft1+aZJdA1oFVA88TpcipNIqpWFsQdUFno
         FjFo8zYQxzTwplx4UhaWTju275OqWqfAqfZunJ/fH2mInH1QG8VNg7r2ty+5KCKurr/0
         pAe2U3/alQjutNT8Tya5l6VHLf5AOIbUEQ1DZyNnxXiQh/DZWGDg6xLk1+wHcrtji40h
         HSF9tOKEH1xM8amxM8lRMoVT5IRdT3FYsZ5LxrCiJkpNctLk6B6HUgHEM3Vs3uxx3k9W
         ZPiW9+IoPw7qPHbjhCfDQjRbRHBhtCNnAYna7LOwQYsr3U3kT+u8nLHen98K8dminzck
         ICpg==
X-Forwarded-Encrypted: i=1; AJvYcCVGZWzpBJZuGqEGOedSfaf38IoMu4Gb5vZiq4xErMG5EQNprX171SuGt9ksIv4Km0jgx9CpJ6cwnGoeXk6I@vger.kernel.org
X-Gm-Message-State: AOJu0YwBSkIDP/s9b6cVwe5g5mjQkuihs5tQx+M6ftHd0l3RUTbvRx9z
	zc2g5pI5oKrN0R7p4jdyYkfYOa6yum182PF9wOmlW3u36pa75GC9HcuY
X-Gm-Gg: ASbGncuY2E+4bOfzwJ7bnPoslKPa6QbHEAnCinON3X3EU+0WmQ4Lvu/30uZpJ/ZX7eh
	n3Cs1nINqtJb4NyXzfx88egUUR9lxrnmPkkbnYhPDhtf3/aH7smW+cbbviZR416VOAYD5SgbBL+
	JMpdy+jJpuVVgDsVxtb17NQBXUbd99GOavhM/j1d21cg1/ux5C/vr87TowRvZsSmkCR4P71q/7I
	+O4swWe36PLfAqnwsivQa4NBVmzqjQv/C/XShwE8+NYBpKWXfd8OLF6xa5ji4ZvN1hCxzowUdjn
	qkzAIi3u9zQ4I85Cs9cweZSR8Y/Xwq9DWAea4K57jLOSkyEKOqx9d6wYx8apjYXUI8jCIHGnVea
	i9OB+ktf+lw7T9iB5f6NdKAo3qJGv6ZSg7SzqUICRZcoojf81cBU2IbzF/a2nUPju+uWm2Znt/P
	1U4XaTc3SoKWriOIFVJSuR/1XOrAPeGQnnqKQ0CzBHs0JqJ3/S9x0=
X-Google-Smtp-Source: AGHT+IFd89BFCO1yVfGGj/d7WwmJs4B0XWtk91ogl+pZD31LxvR6a/qjdmNRrk52I5Z/RtLbiGd/zA==
X-Received: by 2002:a17:907:7a86:b0:b57:2c75:cc8d with SMTP id a640c23a62f3a-b605249e429mr2075004666b.14.1760983701239;
        Mon, 20 Oct 2025 11:08:21 -0700 (PDT)
Received: from [192.168.0.100] ([188.27.132.152])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4949bed7sm7257134a12.35.2025.10.20.11.08.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 11:08:20 -0700 (PDT)
Message-ID: <0e8004c3-1d5a-47b8-99a3-76f690e69613@gmail.com>
Date: Mon, 20 Oct 2025 21:07:53 +0300
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] module: Fix device table module aliases
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan
 <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Stein <alexander.stein@ew.tq-group.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown <broonie@kernel.org>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
From: Cosmin Tanislav <demonsingur@gmail.com>
Content-Language: en-US
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 8:53 PM, Josh Poimboeuf wrote:
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
> 
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
> the format expected by handle_moddevtable() in scripts/mod/file2alias.c.
> 
> As a result, modpost failed to find the device tables, leading to
> missing module aliases.
> 
> Fix this by explicitly adding the "kmod_" string within the
> MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
> format expected by file2alias.c.
> 
> Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME")
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Tested-by: Cosmin Tanislav <demonsingur@gmail.com>

> ---
>   include/linux/module.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index e135cc79aceea..d80c3ea574726 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobject(const char *name);
>    */
>   #define __mod_device_table(type, name)	\
>   	__PASTE(__mod_device_table__,	\
> +	__PASTE(kmod_,			\
>   	__PASTE(__KBUILD_MODNAME,	\
>   	__PASTE(__,			\
>   	__PASTE(type,			\
> -	__PASTE(__, name)))))
> +	__PASTE(__, name))))))
>   
>   /* Creates an alias so file2alias.c can find device table. */
>   #define MODULE_DEVICE_TABLE(type, name)					\


