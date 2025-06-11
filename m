Return-Path: <live-patching+bounces-1514-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5319AD5E7B
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 20:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D4891E0439
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 18:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2A625BEEF;
	Wed, 11 Jun 2025 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDfunmA1"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79A23C8A4
	for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 18:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749667494; cv=none; b=fLFID9S8OaC6eFQWSJ65L/aYLrImPIhMI8tMTpyA6+c2AFUVXYgCvxooHPNv7yTUXbAQFgvAlKn3aExYGx1S5bH5/rTfEhjznadNvu2939Sco8s23tAWNcd0P0mxmX4hagP2QnQ8iDfidz9lnnCOGXTmxObRyrvT1d25pkMfX7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749667494; c=relaxed/simple;
	bh=wac+svBXGON8ziPcVrSLJ4B2YSmTE7hYnL72gXdrIKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0gEuXlY0OC1OXP3WNrtemlDdhg+2Mt1y3sbUcigMFSsgBYO45iMdIxsKCiuO/IJFBRrq6QhvEgJxJADz6uIxZCGZU/YRhe7PaL8qkEAmK4gEDRVMvDpYhmdptJxNB91FSGFtmnPVaQOfZWkMR4wh4Ikx8JnJW/vdmCRMMWQrSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BDfunmA1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749667491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4tzmsQv4WOvggfbfFT6gkBMqKRhm06CcuuIIOc9ssS0=;
	b=BDfunmA1dLsEhr+YG5KvAWrZ1wEr8zWpmMTwescYGSI6PqPJgNm8Gb/FwFsXTNuKaCFRxy
	eJnrB+1tH4JoIbpRAXYmtmutA2fg0OvQD/uPzVyf0QDDaVpx8TuqqHU7EwxUehEliM70n4
	/yoWcz87U+cRkiXlsVSBhOrANVJqqC4=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382--N059S2FMgGXJH6B_f3x2A-1; Wed, 11 Jun 2025 14:44:50 -0400
X-MC-Unique: -N059S2FMgGXJH6B_f3x2A-1
X-Mimecast-MFC-AGG-ID: -N059S2FMgGXJH6B_f3x2A_1749667490
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-53124ae0722so100395e0c.1
        for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 11:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749667488; x=1750272288;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tzmsQv4WOvggfbfFT6gkBMqKRhm06CcuuIIOc9ssS0=;
        b=i5/krJkCWlcuwgIYeX25K4pLkaSSE90j1rtMsc7Q1gIEO3ZpeIvztDfGuJgbMH5/pG
         hQOFI4I5SRfEJuQhYFJMv8v6gn+GeNt5gr4N4p/UEaFB1bVdmVSyVtfHIvSlv5jYgsyX
         sIxEuWqqMRxiqfVpgkDsq8S4X1cXzhArrreWGg7xMjfxkM65KbJIkHN1oM9puBctwa6z
         c/LTFFmmBkVLjcAsBbEATY4IZIyPwklsoQXtrdTUukwJFI7k0SRWQel4fAYfo+koP2Zh
         FWbCmPHxU0MrygnLboTcaIDGvmPCc4ns8kw6E1EbqCrrW8HyFvJcaI2YRz18douFCnUX
         mP9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgiedceJn42VAwrYMueeJ5yPhUNRCrBI9I/GXDOvsdP2yzKp1EfpnK/scQTAhy6xH/HOFEBMaRj9d7B4cR@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ1yoziE/UNFyNX3ozQwGFpEMMTTNAD2GQa18XM5mz0jjkXFWY
	JRxa7lgpE1zt3ijZMy8zWH+pDDEv5qPCxMGGFw2AjA4kiJbjuWH2y8v4XaFzLIJFpjkEIkRIvZS
	PpXRxm3uSlpyqTe2i/vs/t+BM137qFZIC9WxFW/2Xv2Zj13gDWI/0gmL9DdusDe/Uj0NYrBbSLT
	0=
X-Gm-Gg: ASbGncuKXnPiGARjD9hYNkYWAV04fsY/zF7f1nhCOsgWbYxVLwsMCnyvulsuM+i5ERT
	q29b1KnsgjRGLGguFDjlwv24qhWBJJnQGeCo8DltAC8aJQEWDUW8EgupYpVTBHLKsyZMtL68+Cj
	A3fGYvCKnsJjNNOhFduLYPvpFO+wXkONDXzBEPWLJKAL7/aPs0znYtPuDn/1qVdluZ0dBf5FuxZ
	oeZfqpi3azfx+xiMt7jBR5BR7xMm9unc7USU5yfVOyKIEJq0V6cum62muowoMFc1pie4TIX69WA
	d3SyG+HVoofRj8RaR3Rkx3AtZk2zIamA6o0rPhx8I/cnyj4mnP/t8MWfahlz2czMShDOmnehI+S
	CWg==
X-Received: by 2002:a05:6122:338a:b0:531:2335:3f24 with SMTP id 71dfb90a1353d-531233540eamr4025284e0c.7.1749667488702;
        Wed, 11 Jun 2025 11:44:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYph1bi2nQ2Ltt49fwaGderCEkbHTYBGtonyOC7JAuZFD8Gyhdt5tJmovi3OyRetrZeYxwgQ==
X-Received: by 2002:a05:622a:259b:b0:4a4:4144:93b4 with SMTP id d75a77b69052e-4a713b8b8ffmr88519401cf.3.1749667477514;
        Wed, 11 Jun 2025 11:44:37 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a6198650besm92606541cf.57.2025.06.11.11.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 11:44:36 -0700 (PDT)
Message-ID: <8c79b86e-fc30-4f48-bdd2-91ef6f612bb5@redhat.com>
Date: Wed, 11 Jun 2025 14:44:35 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> Add a klp-build script which automates the generation of a livepatch
> module from a source .patch file by performing the following steps:
> 
>   - Builds an original kernel with -function-sections and
>     -fdata-sections, plus objtool function checksumming.
> 
>   - Applies the .patch file and rebuilds the kernel using the same
>     options.
> 
>   - Runs 'objtool klp diff' to detect changed functions and generate
>     intermediate binary diff objects.
> 
>   - Builds a kernel module which links the diff objects with some
>     livepatch module init code (scripts/livepatch/init.c).
> 
>   - Finalizes the livepatch module (aka work around linker wreckage)
>     using 'objtool klp post-link'.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/livepatch/klp-build | 697 ++++++++++++++++++++++++++++++++++++
> ...
> +get_patch_files() {
> +	local patch="$1"
> +
> +	grep0 -E '^(--- |\+\+\+ )' "$patch"			\
> +		| gawk '{print $2}'				\

If we split the rest of this line on the tab character and print the
first part of $2:

  gawk '{ split($2, a, "\t"); print a[1] }'

then it can additionally handle patches generated by `diff -Nupr` with a
timepstamp ("--- <filepath>\t<timestamp>").

> +# Refresh the patch hunk headers, specifically the line numbers and counts.
> +refresh_patch() {
> +	local patch="$1"
> +	local tmpdir="$PATCH_TMP_DIR"
> +	local files=()
> +
> +	rm -rf "$tmpdir"
> +	mkdir -p "$tmpdir/a"
> +	mkdir -p "$tmpdir/b"
> +
> +	# Find all source files affected by the patch
> +	grep0 -E '^(--- |\+\+\+ )[^ /]+' "$patch"	|
> +		sed -E 's/(--- |\+\+\+ )[^ /]+\///'	|
> +		sort | uniq | mapfile -t files
> +

Should just call `get_patch_files() here?

-- 
Joe


