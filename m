Return-Path: <live-patching+bounces-1818-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCBAEC0C842
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 10:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14AD9402E3D
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 08:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570192FD1D4;
	Mon, 27 Oct 2025 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZYzh/uv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546C32FD1A3
	for <live-patching@vger.kernel.org>; Mon, 27 Oct 2025 08:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761554835; cv=none; b=RZtlTYj66KXnqqkuOO1D1AF/0BrRkHbxfHiNq2ziWJ6SSYu0wk0RDpJrmhvHBUULQKd66Fk0L2dG7+lmTBCoAQMATkc9W9z8T359dAmYqh039Ph8e2ev/oq0Vq7C0e6qcJpLVFKAvr7c6mRor9gBGwDTBAVbon3AUhpS+d2W/ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761554835; c=relaxed/simple;
	bh=L6yB8zi8REP/swCl7Av17BttU5r/j+BG5EnDaugEi4w=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUaD1jFhGRUC1CryyxRupPamshNEMtuG9fnwxL/TJE5qdDVH5BvK+c1ybSy0HyoqLnaR8diExWfoZXTzyOwF1d+eyTnST15xphDs2subr6Q1Gmi8r28X1HkQpScR/AKu3YGL+407j9SleBVo1EmHZC6y1t430hTi2tgYJEEOUT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZYzh/uv; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so4493965f8f.3
        for <live-patching@vger.kernel.org>; Mon, 27 Oct 2025 01:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761554831; x=1762159631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=llxyMYDYDt1QJiOwvJpk6RQ31U8QgJmQ3C8aeyRJ80o=;
        b=HZYzh/uvd8ptLT3acA7V+gfirFgNdQwK+XGqfAVEz+7C3TJgKhNumHg0JnbUaYyWYo
         Ufq0GwI8eM3HX0yJh/JEzkhQQSAd8jvlQ28gLVJiyy5iB9ur+Y+dxWI6ZJ3bLeSmq0L0
         kf7mHfCU0ybDQJRFD3Zyexq+7UuGoTfXPAHf58fxWLSiwMjGYfSOs0dlcErrGkryds4z
         pCZ5klopXEDF1rff+41+66dSXPPZa+dIZsRlGsfBaqdPCc9cmXkjqzF3hf0fQ73HaLj5
         lPT7U0i1PFbBOPVFkbiP0ISxnCGhPPUTizjsR6JSYR7IysF+OKPwkFnR/vZmzmc3avBJ
         RUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761554831; x=1762159631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llxyMYDYDt1QJiOwvJpk6RQ31U8QgJmQ3C8aeyRJ80o=;
        b=mr5jO/05IIzp4eNkJfYvjyij7VELi96O/1+Kecc3VzeoNTqo9mZrlgSlE+jn+W+U+e
         GFdxkd6or3jS7oyKJVk4O51yERHDCqFRs/UTjbWGeM/zCr6smnZaaxz/bzyOeXs7lQwB
         MqQf+i/gKAF5gc9L32wQ/LrY2N0kj1j4dhnJJSO8FtaapUR+lR0jz//jlvrzvWWJ/dmC
         D8ujhw2T8afh8qempDxZx+nY7PXXE9vGLwjI8R4KWlC2tdOIId+PHLWngArBLCIodn1s
         /tzxvz0ZXRivnOtshF8DJAJMr16SMUjngqmDMokYjXqsAqcfMvDirpgHa+DfbIxujMjB
         YGlg==
X-Forwarded-Encrypted: i=1; AJvYcCUkJj/fxTKbLvbDzklYgIL9yedldmbFRXB8552LbiV02Jp3t+hWoWD0RMMRTezWVWIO4aRZzv95w6MWRVz1@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl9Cuz8TJBgzTWivdm5if8EpMAE2ASEtEOSQU26VfRM/DqiSZC
	oikjI1B4No9CGwwYqMbJn5R0STkoOcyPPy0+Ocr4x8kQE66vyDQB6MjD
X-Gm-Gg: ASbGncuM3jRwYjo31gERdEXA598qwenmqOI5Y8xG0WnLtAVKBt3n3hGaf3B31v53Sun
	Dmj9VlFknXmPJhvzB3Xqb3C5lbC8feRphktr2cwn8J4jxAcpmeuzq5qks0IPQjWq5lTkV69G10+
	w+XVQKk+lK53dhfCvzpXoP//wR8ZtrLIZhtlhLVU4NYEa3dpG8wppUNWGyuXOGBKTL+zbg+LU8T
	RrkNzPcqR8qw1ZTdje1RJrblTLqn4Qzv4sT8BeYyAqhXFvuxqmOfhgMqA7z38aHYw7aEwfHiqzc
	fb6frpUm7Eo4mIlNtubkzLd+fHGFZ4TJ01fC5KVqJtDkP73RdWYLj606dSkox6ISSyrOen6Z0IO
	wQ3LjKCPL1STITiJQLDOBXbuA7VQ2FwvnDU6bGQmQ2oKjHZMzqkB99YuY8JHD
X-Google-Smtp-Source: AGHT+IGmPorRwgMh/ycuOVlsCFCdyzLjqoKlJVftW4lXoTOXrfSlOItutS9zUJ6ECFW5IHrsQ38MIg==
X-Received: by 2002:a05:6000:1884:b0:407:7a7:1cb6 with SMTP id ffacd0b85a97d-42704dc41bbmr25937090f8f.55.1761554831396;
        Mon, 27 Oct 2025 01:47:11 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::b44f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd489e6dsm123106415e9.6.2025.10.27.01.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 01:47:11 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Mon, 27 Oct 2025 09:47:09 +0100
To: Song Liu <song@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org,
	kernel-team@meta.com, olsajiri@gmail.com
Subject: Re: [PATCH v3 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Message-ID: <aP8xjR_ct9kn9yuf@krava>
References: <20251026205445.1639632-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026205445.1639632-1-song@kernel.org>

On Sun, Oct 26, 2025 at 01:54:42PM -0700, Song Liu wrote:
> livepatch and BPF trampoline are two special users of ftrace. livepatch
> uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
> functions. When livepatch and BPF trampoline with fexit programs attach to
> the same kernel function, BPF trampoline needs to call into the patched
> version of the kernel function.
> 
> 1/3 and 2/3 of this patchset fix two issues with livepatch + fexit cases,
> one in the register_ftrace_direct path, the other in the
> modify_ftrace_direct path.
> 
> 3/3 adds selftests for both cases.
> 
> ---
> 
> Changes v2 => v3:
> 1. Incorporate feedback by AI, which also fixes build error reported by
>    Steven and kernel test robot.

Reviewed-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka


> 
> v2: https://lore.kernel.org/bpf/20251024182901.3247573-1-song@kernel.org/
> 
> Changes v1 => v2:
> 1. Target bpf tree. (Alexei)
> 2. Bring back the FTRACE_WARN_ON in __ftrace_hash_update_ipmodify
>    for valid code paths. (Steven)
> 3. Update selftests with cleaner way to find livepatch-sample.ko.
>    (offlline discussion with Ihor)
> 
> v1: https://lore.kernel.org/bpf/20251024071257.3956031-1-song@kernel.org/
> 
> Song Liu (3):
>   ftrace: Fix BPF fexit with livepatch
>   ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
>   selftests/bpf: Add tests for livepatch + bpf trampoline
> 
>  kernel/bpf/trampoline.c                       |   5 -
>  kernel/trace/ftrace.c                         |  46 ++++++--
>  tools/testing/selftests/bpf/config            |   3 +
>  .../bpf/prog_tests/livepatch_trampoline.c     | 107 ++++++++++++++++++
>  .../bpf/progs/livepatch_trampoline.c          |  30 +++++
>  5 files changed, 177 insertions(+), 14 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
>  create mode 100644 tools/testing/selftests/bpf/progs/livepatch_trampoline.c
> 
> --
> 2.47.3

