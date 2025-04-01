Return-Path: <live-patching+bounces-1350-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0986A77B44
	for <lists+live-patching@lfdr.de>; Tue,  1 Apr 2025 14:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6EB16C534
	for <lists+live-patching@lfdr.de>; Tue,  1 Apr 2025 12:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C3820408C;
	Tue,  1 Apr 2025 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6Ys7oW5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD172036E5;
	Tue,  1 Apr 2025 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743511697; cv=none; b=iJt4crX9oKkP79MOb4Avig9RJoiA/65rD/VYwh903ekf1l8sGYHU52dwR/AJNWfI9KNtObW1hRKI2ZbLZ3Vs0WlRXVPgiBtxFVV54ergjs/V8qCHoCjsnlKQHtOS/GuSkkU6RFdiyX8ZLvqB91aAqyHIZLTBCexznKlBn3TzR0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743511697; c=relaxed/simple;
	bh=Hn35Y7boillhCdJSSjYbrtC+YQvNRuCiMuoiDrQDjfk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmk/+qVdXVoHS4tXacMYLrReb0bVZ+QiadFDyxfEPD2qmSKO6pN3/rIa8pYXi9vM4AEeZ9qQ6Xo7Z8dsQRTLCNWW576voheOA1ttlzx5RLFDMH/pqLC9T9wS97MzD+LaOATuq+psNapkklrT2kYHV4GX6RX+V67SWvehvXI2YLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6Ys7oW5; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so33695035e9.1;
        Tue, 01 Apr 2025 05:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743511694; x=1744116494; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IhOXe4xrLWQg1QgwsFqVSOzco+rqx0QhBazJTWNkxkg=;
        b=L6Ys7oW5yo31N5eImrXj98x7ijIjWEiW0MLwYB5cW6xySDenaZKVrTMHxidlskz5U0
         2yhTv7iqAHYU1jweAZujAj/L0ATIwb8OPn9m5utDvzYHXysnYGLGt90g+OQ/D06Q43+i
         DTIdjHBfkMt5FH7VMjmHNBRhQsXRqRYwy10GLwrN0IdKKe2Ly7/VXdQvc9OWVqy43srl
         0T1d0H2YfudLqOyVb7GNAR6qbh3djJdZfg9l/e2+YwY7ga2uQxKJcXd3mjgxJhIfY7f9
         aXkeMRp0SeMkZiga2WZoUNTFN1SJunNA6V4vR7g7qcgp1/MQM6Xjy/bxDp+BN3wLDX9W
         HV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743511694; x=1744116494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhOXe4xrLWQg1QgwsFqVSOzco+rqx0QhBazJTWNkxkg=;
        b=r2lHH9CKC6rVMyJxAXPBUcPSVU9l2lnrmozco6iLFPt2jr7txZQ5tO7yi32XoDk47+
         YF23L8EKzqo/UgtUvSy4s8uHUs0tHuYXWBye+etuiZtkDhTbsZgb+E/lmdWN4+RB+qbF
         exO1LPclReYprtpuQuAVekci1w/Q6AJTWS6DqBX4Fw2j1FYmZ6g7cviHO/8GWnWf2hor
         Xvh4MHYlt0oA3Uc9k6UmQ3h5am0U13l9nx0UXNChiTFwic1EPsmHD77UK9NJsQhJxE7f
         P5zs2rIPfZ/hnjMSoN8j9AODUyEP8LIxvAWzMxxhONq/7p0DmDxayIpm15Y61LQMrW/y
         RitA==
X-Forwarded-Encrypted: i=1; AJvYcCUg4TcgJKhhhYPfd9KoSVVLlKdjaNYsnV13s0HP84x7IS+85pSNwHyloYAzUDHI362EX9/2iUg96ZPyT1Si@vger.kernel.org, AJvYcCV22kW6TfU9aOwtD1z+c4caTNdK1l9Z8rFzLPOMW/v6iXp0hj8E7h+ePdg1vzCKH7AH5yM=@vger.kernel.org, AJvYcCVIffMbpDEeW9L4lqs3/Xby6eNsV6dNsY5ljHoFxOs//SVGQWjOBfhqnMO4ycdzsvdyFgvoc6WXlTBhfmE+gQ==@vger.kernel.org, AJvYcCVcqGUabbge3+k9gFHBIoBWO93kvCZjOiiQikFJ4LucNGxKXUDkZv059KGIf2+6wdoIoQq4rQ/70z5nNiPD7XUeIioy@vger.kernel.org
X-Gm-Message-State: AOJu0YyehAy/ksbyBnPxc0JffdpucnVuFw09YH6m3q3FKrch5cHIWo6L
	jrPhZFEPd4vPsafCSMSGI5zgo7GrXA6XKGoXsYc3repH1jdgYcQaUTynEO7Q00GRIw==
X-Gm-Gg: ASbGncuvFGsWJ3PO0FvkafxHhLlENlw/VIgikEbFPzmsg1KITKM9mAQ6semRe5O48+s
	gqUvQUAxJmpNiembJN3uoSSTCx2SmhmkN0oBAQiZojEmLHNh2rE3M5V8eb0ayJHh6nlUkUslF7L
	71V6u25MTk/oGEExpWjlCKTgEp+Jx0GIN3vt9gzG9/PMb0LZRsf26b3ChM1Js1vWy1p8BSqaEIH
	oI1MTfs9nPzNGFWhYEZ1eoBSV+CwVsWeyKdpT8uw6LqyqfkVuwUsk+IBnCbg9/r4FJyVRP8SnQA
	z0If+XY9IAJAkxUdwQSJIM73Uke6vSeJjnbmNjivlg==
X-Google-Smtp-Source: AGHT+IHFGVvpXaO6oBAfea5m4iRVIFgk5rQKky/21TQY7Ax3YRJMq6NtUyS4+SEkcfaP8JICKNn9KA==
X-Received: by 2002:a05:600c:4606:b0:43c:f3e1:a729 with SMTP id 5b1f17b1804b1-43d91170787mr102959385e9.12.1743511693699;
        Tue, 01 Apr 2025 05:48:13 -0700 (PDT)
Received: from krava ([173.38.220.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e082sm14281943f8f.69.2025.04.01.05.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 05:48:13 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Tue, 1 Apr 2025 14:48:10 +0200
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	"Naveen N. Rao" <naveen@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Vishal Chourasia <vishalc@linux.ibm.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch (v6.14)
Message-ID: <Z-vgigjuor5awkh-@krava>
References: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
 <20250331100940.3dc5e23a@gandalf.local.home>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331100940.3dc5e23a@gandalf.local.home>

On Mon, Mar 31, 2025 at 10:09:40AM -0400, Steven Rostedt wrote:
> On Mon, 31 Mar 2025 21:19:36 +0800
> Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
> 
> > Hi all,
> > 
> > On ppc64le (v6.14, kernel config attached), I've observed that fentry
> > BPF programs stop being invoked after the target kernel function is live
> > patched. This occurs regardless of whether the BPF program was attached
> > before or after the live patch. I believe fentry/fprobe on ppc64le is
> > added with [1].
> > 
> > Steps to reproduce on ppc64le:
> > - Use bpftrace (v0.10.0+) to attach a BPF program to cmdline_proc_show
> >   with fentry (kfunc is the older name bpftrace used for fentry, used
> >   here for max compatability)
> > 
> >     bpftrace -e 'kfunc:cmdline_proc_show { printf("%lld: cmdline_proc_show() called by %s\n", nsecs(), comm) }'
> > 
> > - Run `cat /proc/cmdline` and observe bpftrace output
> > 
> > - Load samples/livepatch/livepatch-sample.ko
> > 
> > - Run `cat /proc/cmdline` again. Observe "this has been live patched" in
> >   output, but no new bpftrace output.
> > 
> > Note: once the live patching module is disabled through the sysfs interface
> > the BPF program invocation is restored.
> > 
> > Is this the expected interaction between fentry BPF and live patching?
> > On x86_64 it does _not_ happen, so I'd guess the behavior on ppc64le is
> > unintended. Any insights appreciated.
> 
> Hmm, I'm not sure how well BPF function attachment and live patching
> interact. Can you see if on x86 the live patch is actually updated when a
> BPF program is attached?

above works for me on x86, there's both 'this has been live patched'
and bpftrace output

> 
> Would be even more interesting to see how BPF reading the return code works
> with live patching, as it calls the function directly from the BPF
> trampoline. I wonder, does it call the live patched function, or does it
> call the original one?

yes, that should work, Song fixed some time ago with:
  00963a2e75a8 bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)

jirka


> 
> -- Steve
> 
> 
> > 
> > 
> > Thanks,
> > Shung-Hsi Yu
> > 
> > 1: https://lore.kernel.org/all/20241030070850.1361304-2-hbathini@linux.ibm.com/
> 
> 

