Return-Path: <live-patching+bounces-1274-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F31FBA5FEDC
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 19:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D72467AA9F0
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 18:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E4B1EB9F4;
	Thu, 13 Mar 2025 18:09:08 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE821E9B26;
	Thu, 13 Mar 2025 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889348; cv=none; b=LZzAzipW6368DLQfmVDIK4iV7tfDjHHnEmRg1njIGC3V87VCxy/vs8lwcPqpXuKqM7TIY9w9XPxgE6b4IGuUTlv8vMu/lPnA7Desu1594vPTGvPxUYyPUH81Dfh3MYvdnlMWCkkGENgqE5Rp2EWkN8A/sYy9Rw+OqPc9Lx0CXrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889348; c=relaxed/simple;
	bh=/2TX7oqp5EZ59EfzAb/BphrBtCTWtTDGm2PFTAUVHZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhGbdVDuoh4AeLOAXJsfZ2rA+BtMtmSTeoGj8IgBbJqHLYGWTJ70NMsE52u+5B230QuZHe5oBstZDqO9+wecj8PfxrTka5jRdZHaknXlUh98FWxqxH22EHMDxd3zO9P+Yzm1UP+EGvSbGKC04XIRz/GhNcGKs1N4P7riSnBc62Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac2b10bea16so256362866b.0;
        Thu, 13 Mar 2025 11:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741889344; x=1742494144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaouCn+gVoU+eTcyNhX+f9Nv54n71MJJFoVOkqHdXiY=;
        b=EYZENX9IublUrY3iv4E+vHW+HwLoeihjHjgmHGSDDURHTwuHhYwowS4KuORS73CexS
         Lhh7AaZwpLexAvFt6+GdF04TFHTIGWadzaSyzB3bNkCKEC1DDoJ1x3+Vi9b5m8VgeaKc
         7KEK32I6TcFV+db4TXAbgsM+rxJyCFqKKkU2XkvOgXFA+RBLUm+Td02eFjJqtmGmsMEV
         xiTHNDo/tEzsXY99r87guuDReD3opg8t9/I3hH6fE4zcWi0CT14OuFpo4d2uEVEgnrmM
         CBRE2jVy0hv0DXP2eZCHcyDbJ562KfdqkiZSk5JKF96hjTlWwq1AqlQvSvlyyhNc0YFw
         1YxA==
X-Forwarded-Encrypted: i=1; AJvYcCVw/V5s+zVVtA/Aw5b66Dl0g1qQcGE7n4XcBPgdI0fKW/HFk5VGOcbhkt65mUEzlMa3Uc20YbefN+w8gH/76C4sWg==@vger.kernel.org, AJvYcCXJk4y9s95SQb20/j1lF4dRsO4Jv0JoyEYJexL/IzgKoIxzgmIX/L1pvNjY+/ba3Cp0gN0heXpSMnKSoig=@vger.kernel.org, AJvYcCXQ5n8ewcDEC8XqutVm6JNnm+GclVjUnJyA8bxJFJ3dP0y0OiN5Vi1kUkLmmWW0mXP9ilFGzUN2hAuCKpp8Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzklHC1xpgjeU0GlK6V+zOBAwqWQNA9YifWKu/srw1If6MBjpfg
	Suj8s21goE109FY3Np1rx2lz11qphkGhyi9mQjfHsfnyUAkBQOkH
X-Gm-Gg: ASbGncvFnpPLePlqorVBdtfaQZwc7gy5+4KeQuQeOQh8Y2VVARpH0X9juOLfxpB3my3
	mA9uKU/CdBdBomFJ/trdHBZ2lX5Q9wBgsQHr8ze65u0Let7fBcSDTxxQo06EJfV3CYTDRboFs5F
	07pdpYjaaDlF1ny+o2sbWvha1pgvySfJhnX1JlXPQlcgObi6AaY1B+Syt1KyPkgW+Mswp49rWKJ
	pBmrz66l7+gLArTlRMSEgrVN14+5IOW5UYuKFVdPrTRfXK/O8HPAPQ8LninV+q4cqe1R3PFbnQJ
	TlSwi6IY/ueOLikHH0fvrxz5Lrgkfazdlwc=
X-Google-Smtp-Source: AGHT+IH9avSX5v9rVOb5M/GqkETrqEWlWjAuanfOK7yi22Ikj/OiRCa+LiNivmTskXBxpPr+KOjuBQ==
X-Received: by 2002:a17:906:da88:b0:ac1:fcda:78c1 with SMTP id a640c23a62f3a-ac3290221f0mr50851066b.34.1741889344124;
        Thu, 13 Mar 2025 11:09:04 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:8::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3147f0bd3sm109488066b.67.2025.03.13.11.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 11:09:03 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:09:01 -0700
From: Breno Leitao <leitao@debian.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	mark.rutland@arm.com, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
	kernel-team@meta.com, Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>
Subject: Re: [PATCH 2/2] arm64: Implement HAVE_LIVEPATCH
Message-ID: <20250313-grinning-giraffe-of-holiness-3dbda1@leitao>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-3-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308012742.3208215-3-song@kernel.org>

On Fri, Mar 07, 2025 at 05:27:42PM -0800, Song Liu wrote:
> This is largely based on [1] by Suraj Jitindar Singh.
> 
> Test coverage:
> 
> - Passed manual tests with samples/livepatch.
> - Passed all but test-kprobe.sh in selftests/livepatch.
>   test-kprobe.sh is expected to fail, because arm64 doesn't have
>   KPROBES_ON_FTRACE.
> - Passed tests with kpatch-build [2]. (This version includes commits that
>   are not merged to upstream kpatch yet).
> 
> [1] https://lore.kernel.org/all/20210604235930.603-1-surajjs@amazon.com/
> [2] https://github.com/liu-song-6/kpatch/tree/fb-6.13
> Cc: Suraj Jitindar Singh <surajjs@amazon.com>
> Cc: Torsten Duwe <duwe@suse.de>
> Signed-off-by: Song Liu <song@kernel.org>

Tested-by: Breno Leitao <leitao@debian.org>

PS: I've tested this patchset with the examples from samples/ on a arm64
host, and they worked as expected.

Thanks
--breno

