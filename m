Return-Path: <live-patching+bounces-1812-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4665DC0B2F0
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 21:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3DF43BF5E3
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 20:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC1D23EAB2;
	Sun, 26 Oct 2025 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZ8kl16Z"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275E62222C8
	for <live-patching@vger.kernel.org>; Sun, 26 Oct 2025 20:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510460; cv=none; b=bYI4V3ILgQfbmcpC8evMHgwLRRkw/P5E0Sjka6pch1TJeZN6dFBRo5qJOCqIbGhllAVvYnkCBrmnY4m3SZKLdlZcIZ9bLpIp7C9wO5ZsDMCpEP+OZmLoqhgIqWqnQ+qTwGMBVnJTUyCSnqNGGZA8s46jN8yH1g0kL2tCERPRghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510460; c=relaxed/simple;
	bh=bCRYFVf/yj26So76o/UscaSGcOLCs2R309YdgNO2eV8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WS1UqoDzsIMM9KGxhd14DbmMqfpngxqsDgPuw51hnxm2blze0unpXYjXi/YRTw+Z4xVCL5//OJi3Nk1SvvMY1xi8jjl1xHsSt9kkZ+lMO5usMC0nuNqTVzMRGgaR9yHV/2744+rCzf+C5BB6yk8s60ptRp5MuL7KESZyoP82vrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZ8kl16Z; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-475de184058so4215705e9.2
        for <live-patching@vger.kernel.org>; Sun, 26 Oct 2025 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761510457; x=1762115257; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pblCzHnA/TD1DlfgnXYI2tr2t1P6JwQmaCDKB+tRFYY=;
        b=VZ8kl16Z2slDJLPqmZPO2HXdf5WyvwU5JOx8Qib6oOSQZkPXaOtqMTMu6q9J+vYcjg
         dWvU8mbri+blOddmgbzsHRaj/iXyHAu9obemiTG8ppUr5zNyb5id67zkQQ5Q+Jga4gh8
         8DN6oLTScA+vPehRo6xN/fL5weeVYdwyOV44SpOEfMoBtfNV75AsvteVtM2mIAboZFgA
         8+L74iEkcLNRutlJskkVCj6QNtDbnOvRiTuBQmQTd2s/QyV1G6R5b6UonErnJyrYPYxY
         mMcgKYk4+RmDT0OdV8hmS8nXcCA6LG3XNIYH+eH+kgsz3zO0+XnHFoEtFgei7HEhjc3W
         x4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510457; x=1762115257;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pblCzHnA/TD1DlfgnXYI2tr2t1P6JwQmaCDKB+tRFYY=;
        b=GE94gwED9pIf0vqwChjeNx5SYApy2dS6ziPZhrOMf9Tq5qT/BNQkXBmG+wwgN+0v46
         bW6mJC+LD2gOE4wb7Z5AvPpm+MjTTs5gKpzvk3YoFUaMz//hY4em/fpeAzzLYBNWWiVd
         Qlc5ZvNR0hcJ0VjsE92mVbOaV9f9Z5JYWxy4uuVM3IFpm56GRphCj2KW7gGIE8BUlRJb
         Zl+vhMTttI0cJWId3Y5nC4KLjFibCofINDwnfNud1TEBPuZYOqqe8zrIDSeCKljxDVxp
         5pZuLqhR/LE1SJX5LxZGMnJvLkQmIZ1EKAxjiwZbMYD9F2vs6EBWDL4pNPRh9fG8y37A
         6ZWA==
X-Forwarded-Encrypted: i=1; AJvYcCU+EaYq5YTVO3buNMDyveh+HzWrFb9NbyD00ODQHULnM+D0yAKdlqj0EYFUVh58uEJo3c0soHNjAWFY7B21@vger.kernel.org
X-Gm-Message-State: AOJu0Yys2Q5NSEB/PRzo9PdAr9GcJRpaiCAc7paCU48N3cF5lgKavIni
	iwSAd5+l63xol3wxorVgdRdaF9J4Qj27ULfiWLcJ2ygv8hK8ggQoF5FP5G2k5A==
X-Gm-Gg: ASbGnctmV0Ct1Upz57cqXlp+uIOD+ER3K7INmDOMrXj/UqRDZlTQpbU9wj336Ndq7cq
	A5gPAeoqH9WWOVQsrVpxFtw12iRdES+m3eKvQjxAlrft97jHZM4ucZDxDa/iPLfsL0AVt1MI5di
	FDxLPv2c7QXrmxu75BflzjXkJuggsBTtyFOrtlFBryhyIQ2e1czbIFJLPKOvN+q0s3+IVFCKi+r
	9s+69JkjaPUfz3qYK1PMx2IL8/YCeDjM9I0L3LCG6QF7HhZcoKzraXjhOz+6h/O7jJjcJ/Z3pjc
	YokXvGhARhJqMhWVM1TFJT6PzlsbHsMCD+7Dn0mAfUHjuaVcJyA6GbZFmqdWfv24S4bwpzYLq/H
	dC0ah4OvMG4KhpqTIEA3I9J8qkq2rnswFOKc0dx+XZBq90r3bKESKD85MwKzMv+Xm
X-Google-Smtp-Source: AGHT+IFlHbsfbgm+f6PZD4U6LbUt6zcC9Kc4REe2auj3h2CrWE2UTufQJB1Q/D7zVf6QyTHhVZYEBA==
X-Received: by 2002:a05:600c:83c6:b0:475:de12:d3b5 with SMTP id 5b1f17b1804b1-475de12d752mr48711745e9.34.1761510457198;
        Sun, 26 Oct 2025 13:27:37 -0700 (PDT)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd48a07dsm98111805e9.17.2025.10.26.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 13:27:36 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Sun, 26 Oct 2025 21:27:34 +0100
To: Song Liu <songliubraving@meta.com>
Cc: Song Liu <song@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>,
	Kernel Team <kernel-team@meta.com>,
	"olsajiri@gmail.com" <olsajiri@gmail.com>
Subject: Re: [PATCH v2 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Message-ID: <aP6ENht0hNVcVYbf@krava>
References: <20251024182901.3247573-1-song@kernel.org>
 <8412F9AA-FEC6-4EFA-BACD-8B1579B90177@meta.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8412F9AA-FEC6-4EFA-BACD-8B1579B90177@meta.com>

On Fri, Oct 24, 2025 at 08:47:08PM +0000, Song Liu wrote:
> 
> 
> > On Oct 24, 2025, at 11:28 AM, Song Liu <song@kernel.org> wrote:
> > 
> > livepatch and BPF trampoline are two special users of ftrace. livepatch
> > uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
> > functions. When livepatch and BPF trampoline with fexit programs attach to
> > the same kernel function, BPF trampoline needs to call into the patched
> > version of the kernel function.
> > 
> > 1/3 and 2/3 of this patchset fix two issues with livepatch + fexit cases,
> > one in the register_ftrace_direct path, the other in the
> > modify_ftrace_direct path.
> > 
> > 3/3 adds selftests for both cases.
> 
> AI has a good point on this:
> 
> https://github.com/kernel-patches/bpf/pull/10088#issuecomment-3444465504

makes sense, I think it'll make the code easier to read

jirka

> 
> 
> I will wait a bit more for human to chime in before sending v3 with the
> suggestion by AI. 
> 
> Thanks,
> Song
> 

