Return-Path: <live-patching+bounces-1796-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 650C0C06118
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 13:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EE8D19A2AA6
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 11:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C3C30EF7A;
	Fri, 24 Oct 2025 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="So529veH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1422ACF3
	for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306175; cv=none; b=YujHMGytY1ELH1rTj7nbYLhiaTJcZTfynCfYpwpLWJkOMKIO2BGsolYF/8dY6OrV7b6DwBR5eo2nWMNE6U4pSx8c5iHpnTZe8Ne5Ivs4wejRelTdfsyvpMEZeppzj4NpHJm1tpsOw7AyhZOdBplZxxkl3FKceywvKiRTjALt7CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306175; c=relaxed/simple;
	bh=BSa+n0RHtBRMZcEWJek59r2Jv4nIb4dvimkE2lkcU5M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWT2oZHG98/TuYTn/iFfEC0TxOUxfQ5rRM8EZBoQONfhjqJrMJaKNTq3wu+2ifk85fjQzwlmYFkx/B71JT9tiSyfRZFTP9qeGgyaDjzAUSuFG59rykmduvj4N2J8Tgq/mr0afoy1JJ87jKZToJ6wy5vBgHuUXqEheYTZChm3398=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=So529veH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-471b80b994bso27696385e9.3
        for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 04:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761306171; x=1761910971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dYSOpLWf0KKSMlI5IP80glPUH7vqI7+Tr3W3w2SASQg=;
        b=So529veHjy38XsuZYlINGFEIeO+Brf0ht4wtROg2ZPr06pn5Tj2zewjpGottF/qylw
         NLSS/MzfNONDrBHY1aTs7s0xiwj1EYeC2Aslh+Wh6AO3oqE58oNquIxD8IuYVoZMxP3K
         txdHsSmh4st4vr+09ULp3XpJO7B7wjBmQrYX6A318YtmY3JSj/LAWgePlGL/weDcceIe
         /FGmRjVc7vXLMMX+ruo78ScnrN2Ui8QpNeZ6bgUTJAoiMwmpurGLHjml6CSuVx1kE7jm
         ynV0kbTs3hc/TE9dqBGnfliZ6uGf2b9qiqyyXUHKyCQhTYC6FkLuMLASkDdEYx10tHbs
         sjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761306171; x=1761910971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYSOpLWf0KKSMlI5IP80glPUH7vqI7+Tr3W3w2SASQg=;
        b=iepcLePyfzMo5IXn9g7Klho9DPEA2FHamjxNiY7CxQMloXLv1AhZTnyfOJM5M8/MFU
         ympWWmUlo1chdHi44Uc26ZHYR3L50IFi0fG8Fs7zRdxJuP85On/nkB/tRRFY2Syz2XZI
         k9ee2n07d93u7gm8l4g78V+GjnneRCSDSSzMdgKVLj+Sw/HWFUZnu/55dtSEn5noATT8
         pwwF6umc5ZSHbDWRSZgVrnJOwfYpWH7e1diU+aQSg5iRcgv4ho+nMNjrbFdkVQ0rO99R
         LWaX/bnxYdh2sH/FcNJNqsBGI5KuEbwICLTAMgIKkSdZEo7aUcar0iMx2Wh1rqOpbiJq
         W2Rw==
X-Forwarded-Encrypted: i=1; AJvYcCW+B00oVFcX1mWhymUitntYfGHNXzaFjgfim340W1X09NRWzjtzCz7uOg4At7Wi0N8SAgGxiENAmXnYzUXA@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfj0uH65D/YhlOvuhXX5n4oHcw5C/KkszA2IeKejwOJVuzTsHv
	C9WKOES6YW9l/abTwIEHyG8+EUbIMb7GhWavsFyDo3llThUTNLphP3ZO
X-Gm-Gg: ASbGncsqtNgJGPdH1ic5SR7NyujMg4HvmdShCARAfwQfRoKM3Ci+S2mbggjR5y3dMQE
	SGrIG1DuPK6QNsV+J6F3ORqoMqDt+9PXuUP1lJ06wWiMoyJfCVPFwi0eI1M5k5KB1atikV8Km8y
	fp2blVEs6/CK/kGwgQTqwZm5OMjNDr9WO8fnkmpkM/dZUhFzzDT7KcUZH1qqHDhPZSP8pxdwNsz
	eZ+/tNONG5KStoWfwT/0A7ZTyV7iZXO/G1v3NnP4SewPa22WurqXcmtaMSzKT+otWc+y+JHntot
	rJ/UUv5Z1+LUWPOLnbNXNMFhBthXGYObk+v5BnFY6tVE3JNIV5SGb5FHPUArnzFW5R7PvJ4kI3Q
	MsyXiDSOHtmlmXfWiXr/r1McfsxszpaTPKhcn30nDGMrCKCOZT+bfSQKBXsM8
X-Google-Smtp-Source: AGHT+IFIUsw6TyOf0Ycr6/XFbQuoCfiAQ0G0a0V5A5EXttedAZG47NAs1I680hPCSVoLr15fOIrshA==
X-Received: by 2002:a05:600c:3e12:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-471178a74demr202375115e9.12.1761306171044;
        Fri, 24 Oct 2025 04:42:51 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::b44f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ecadbsm9269121f8f.45.2025.10.24.04.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 04:42:50 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 24 Oct 2025 13:42:48 +0200
To: Song Liu <song@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/3] ftrace: Fix BPF fexit with livepatch
Message-ID: <aPtmOJ9jY3bGPvEq@krava>
References: <20251024071257.3956031-1-song@kernel.org>
 <20251024071257.3956031-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024071257.3956031-2-song@kernel.org>

On Fri, Oct 24, 2025 at 12:12:55AM -0700, Song Liu wrote:
> When livepatch is attached to the same function as bpf trampoline with
> a fexit program, bpf trampoline code calls register_ftrace_direct()
> twice. The first time will fail with -EAGAIN, and the second time it
> will succeed. This requires register_ftrace_direct() to unregister
> the address on the first attempt. Otherwise, the bpf trampoline cannot
> attach. Here is an easy way to reproduce this issue:
> 
>   insmod samples/livepatch/livepatch-sample.ko
>   bpftrace -e 'fexit:cmdline_proc_show {}'
>   ERROR: Unable to attach probe: fexit:vmlinux:cmdline_proc_show...
> 
> Fix this by cleaning up the hash when register_ftrace_function_nolock hits
> errors.
> 
> Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
> Cc: stable@vger.kernel.org # v6.6+
> Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
> Closes: https://lore.kernel.org/live-patching/c5058315a39d4615b333e485893345be@crowdstrike.com/
> Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Acked-and-tested-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/trace/ftrace.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 42bd2ba68a82..7f432775a6b5 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -6048,6 +6048,8 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
>  	ops->direct_call = addr;
>  
>  	err = register_ftrace_function_nolock(ops);
> +	if (err)
> +		remove_direct_functions_hash(hash, addr);

should this be handled by the caller of the register_ftrace_direct?
fops->hash is updated by ftrace_set_filter_ip in register_fentry

seems like it's should be caller responsibility, also you could do that
just for (err == -EAGAIN) case to address the use case directly

jirka

>  
>   out_unlock:
>  	mutex_unlock(&direct_mutex);
> -- 
> 2.47.3
> 
> 

