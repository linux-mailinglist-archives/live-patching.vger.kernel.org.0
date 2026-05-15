Return-Path: <live-patching+bounces-2833-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WB3nERMLB2oLrAIAu9opvQ
	(envelope-from <live-patching+bounces-2833-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 14:01:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A4B54EF82
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 14:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0570E30F1DAB
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 11:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E67E47887F;
	Fri, 15 May 2026 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vambGVoE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3DC478E3D
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 11:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778844730; cv=none; b=KrVUHfCAQXnZuIo36sdOmx46v5Wp+WPWRtd5uLjvuLlAdniH5vsjwczWu8dAwf/sQwChu8yOn4/dGR/nFHlh//WEHVFGpooohYEV8AQwlflyK4BRDRv/vh9wv4KV6eYxC3pB9qHBhubavgRCREFz6ywCoo74edpDqyW+0ItSlm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778844730; c=relaxed/simple;
	bh=ILFfSSwiIHS3xksI2tYP/10VV1qXzWXTFy+yC9JgmLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u82cSyhqgK1UyqbQ+B1ImYE9z64mogZ+O0MjCQYVqeAtCu/QQiPWd7uu6i/x4BSX3xUA0/fYZduo+rzQb9gJOcQlBSOH86imRq0Coul1HUo3sNMIFo4hp2DfGYZFkFgGUQMIMwRV4lAxQjaxsbRddK0nwm+HM/9Y8aYVZYgLNgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vambGVoE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so745e9.1
        for <live-patching@vger.kernel.org>; Fri, 15 May 2026 04:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778844727; x=1779449527; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=un4xKj6dT6ED2wP/JPzbfl3yuNb8MArO48PVmah0dIc=;
        b=vambGVoELPGcNJ25K7pgusr83BnwxT1GtoHqdh+oqu5coSLmZlmFYJxpi9oRuvsUl9
         vPbGVRtOEMaO5r2S/U6i9m8gR42aZ6zL5LaesL8WIj82sBM+nkK5V1yTEd5i6SDO9TFr
         UyduaK4UvYAaf+teN4PBRMo7Mrf6kwOMAOJzm/fmjlXZdjx0J8ukTwEm1PAzO9XhU8TK
         fJrKAhESY+tQ5PsWiRWtByRgvCIPtxqNu41tHDUaHNlpaHRALMW/IqPD+ltRkzC5Vd7K
         uKs453fGzAWyqxaWdgKTS82beNpLRYDNnQlRsA1WQEN2CasGe3jUvCZNDqPAAI259B76
         HPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778844727; x=1779449527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=un4xKj6dT6ED2wP/JPzbfl3yuNb8MArO48PVmah0dIc=;
        b=gXQVwlF7tLhvw895VlzZSxt9THfP6A8w7YwhCalBrEuSWMALld+HKXRd55rjkulz56
         sLazEXn7LXAf/aa9CkMXRKWxXVQI4LlBCJlWRM0fcq3bNdaZoAscj5gFKlmLd9UFiS49
         6La+2taW08Kpty2lW690WFiUKGlqK1mlEZbXL6HatZvZV8dw1+p5SeW4lBjQjjbtgja/
         sYKFpFHPl13zq4A1WcDPT/6vtEf6t2IFYIfe2y2HN0mkklhGdr8z70IEcCm82xw2OE9l
         MReqIOf0o6oa/+OhaG1PbE1QmeDN1loxpiuufRp5+UDDc9qBkcJmcsBgezXrSOyusIir
         NcBQ==
X-Forwarded-Encrypted: i=1; AFNElJ/OYM3muhineUG0IoRO2YU9MLlnjIgrNG83RvJiTuSQNTTvh50KnEPoS4zu1367DcOqr9kugZck1ckhzxiQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9PCxwh4/Y0G563Evgji6md9arVc8Ja/ibrOct30Kh6h/QUPUt
	3lcgrFoWPprtoJOFphi38ch9igJBCmA51lFEeBU8t/yhqd7VuplvnlZmZggUfm7B/w==
X-Gm-Gg: Acq92OEHYPje3yJa1EvMUQuDw2ukF+nrlJrb2x4FbPXeIDLayQnEvscbRpTq2QrOkhk
	Esl4tILDqR0j6kqgaCV1HU/VFpksfxZTPzyyA6r18e+P9eAbLsnt4UauxYRNwAmOUfSLH3TK3bN
	HGUWN17aAcPJrHFjqKTs5f0L34629tho3EtBd2fqgIs16WTBITl+NfVoCYe7ddxi4QQrTXZS4So
	VGlc/fCi1XfaAkpu8O4bMmc3xdSu3dRNtbarFNIStWpXHsFkf6iKmHVY5+oG3OiaHE7cECqrHTT
	IG0Jx8DHp+UlCkGRNiIhmP6BP4hGidCY2IF2gNFF/rhqBNt0BX9OTLOB3N2IeM8nCOUU90bWuTO
	uthUUXA8CyAAsSj2stp3ZCdnprAAsgckSvFOxI+r8ThDpcaZsg4pAdEEgYIly2aFSmJCEH7NMz8
	4y9NMsZYyMDqQG3nrCZzy7I1J0EExt1QaVEGHXteAMDVleg+5YgDq2
X-Received: by 2002:a05:600d:6443:20b0:489:1ace:d0d3 with SMTP id 5b1f17b1804b1-48fe8720282mr611985e9.3.1778844726885;
        Fri, 15 May 2026 04:32:06 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a19a0csm14106306f8f.20.2026.05.15.04.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 04:32:06 -0700 (PDT)
Date: Fri, 15 May 2026 11:32:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <agcEMEl-QR0g6DgF@google.com>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Rspamd-Queue-Id: A1A4B54EF82
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	TAGGED_FROM(0.00)[bounces-2833-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[smostafa@google.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Tue, Apr 28, 2026 at 06:36:35PM +0000, Dylan Hatch wrote:
> Implement a generic kernel sframe-based [1] unwinder. The main goal is
> to improve reliable stacktrace on arm64 by unwinding across exception
> boundaries.
> 
> On x86, the ORC unwinder provides reliable stacktrace through similar
> methodology, but arm64 lacks the necessary support from objtool to
> create ORC unwind tables.
> 
> Currently, there's already a sframe unwinder proposed for userspace: [2].
> To maintain common definitions and algorithms for sframe lookup, a
> substantial portion of this patch series aims to refactor the sframe
> lookup code to support both kernel and userspace sframe sections.
> 
> Currently, only GNU Binutils support sframe. This series relies on the
> Sframe V3 format, which is supported in binutils 2.46.
> 
> These patches are based on Steven Rostedt's sframe/core branch [3],
> which is and aggregation of existing work done for x86 sframe userspace
> unwind, and contains [2]. This branch is, in turn, based on Linux
> v7.0-rc3. This full series (applied to the sframe/core branch) is
> available on github: [4].
> 

Not sure if related, but after updating my toolchain
(aarch64-linux-gnu-gcc (Debian 15.2.0-4) 15.2.0), I hit link errors:
ld.lld: error: arch/arm64/kernel/vdso/vgettimeofday.o:(.sframe) is being placed in '.sframe'
ld.lld: error: arch/arm64/kernel/vdso/vgetrandom.o:(.sframe) is being placed in '.sframe`

I applied this series hoping that fix it, but it doesn't, so far I
have this hack :
diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
index 52314be29191..53bdf757ee44 100644
--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -77,7 +77,7 @@ SECTIONS
        /DISCARD/       : {
                *(.data .data.* .gnu.linkonce.d.* .sdata*)
                *(.bss .sbss .dynbss .dynsbss)
-               *(.eh_frame .eh_frame_hdr)
+               *(.eh_frame .eh_frame_hdr .sframe)
        }
 }

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 60c8c22fd3e4..759903acd6fc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1064,6 +1064,7 @@
        /* ld.bfd warns about .gnu.version* even when not emitted */    \
        *(.gnu.version*)                                                \
        *(__tracepoint_check)                                           \
+       *(.sframe)                                                      \

 #define DISCARDS                                                       \
        /DISCARD/ : {                                                   \


Thanks,
Mostafa


