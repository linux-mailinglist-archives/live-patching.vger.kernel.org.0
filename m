Return-Path: <live-patching+bounces-1344-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A19FDA72E9F
	for <lists+live-patching@lfdr.de>; Thu, 27 Mar 2025 12:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F506178C74
	for <lists+live-patching@lfdr.de>; Thu, 27 Mar 2025 11:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD13920FAB2;
	Thu, 27 Mar 2025 11:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ua7daI3E"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD54F21147D
	for <live-patching@vger.kernel.org>; Thu, 27 Mar 2025 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743074123; cv=none; b=HHZUuZAvvFNnQF0f0W+VT4e6Ed9cBgL+Q9ITYzwxzJkfLSIivdodnL9RDn0nEFGorAEq/+7BVXgnLUWYCoG9X3yGhDPjVHKnjlvOltJCaa1wmo1rArFzs71VKtcL2mbGLGRJ4VvgJ1NHpt/u4vWJ1fnbqiIIKCRBdJ5aUtbJUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743074123; c=relaxed/simple;
	bh=Lb97isTLBEeOVnMF+0hR3SCtW77apQZ6W9iJ3L6spPk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=unFHnScUeYXM52EJQt6hYxeE3MFA6KazNSvJe1m9+urdqy8i6X1twmlLRWnDKDctgTBtutMr8/9/gIh7/1HblZAM86B5C2UKSDCshesTzUhp2IP+2Qs7LAzNNX8uvmQBO141jzjmwQz6GdjmU8UgDt2VtWCivQowrDHCceh9jPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ua7daI3E; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so5863605e9.3
        for <live-patching@vger.kernel.org>; Thu, 27 Mar 2025 04:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743074120; x=1743678920; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMODiyhJzHUS6gKDF2pRi/gZt3v4YGP+Fqt7967m3t0=;
        b=Ua7daI3EvYZDstf8j3kQsF7ViSlzxPEarN7A6yQgsr+sHX7UEv9V+c15/hX54TnGph
         p0EawDGgLDTHJhpTwb6G+Gel64UOFU+zcfxe5cbAl7Zwj4vkZK42Q+3jdAmMhKazqqh9
         CZ2O+VZdg7WpDKgVBlTA9l4fgP7F1is870eL+iAsRTuNg8fctwMn6TdA6FfZlOkp+IVg
         0Np+HwECM398A+DtOHbZ+vj5Ddh59TYZRNuTzGfNza6A9L49zjF6dygpKniKU+GCLl0t
         uBsSoDO5Je8N/kfSQbSUghJpD1wK25mftQ+Do/FjYPkqs9TwQEz38rebOX1MT9lhWuyO
         xNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743074120; x=1743678920;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DMODiyhJzHUS6gKDF2pRi/gZt3v4YGP+Fqt7967m3t0=;
        b=AlvhduUO0otthU0RGyEfpxbrY3wyOYIwAtyUr1tOcsLIeOR/JtWBpfgFS2wBi5G+lh
         Q6CBg/rT6c+iK0f0MmaPpDXY1y9sPhcL6B0HI5zjlRak7q4Og48Zj4n56KzOp65vDdGH
         VBQC2SMBcs3jTW7CRtKPAOEZ4U4jFJFSOR1piM/v0GIc2E3qV31gP3WIaylyqFh40oXU
         dNF5RaIpzqaAqbRKxInobflu5VSr39AdXzss3LHkeDsN4zj8uU39VDJ076Ibw0QNlZHC
         Ta0LiM4QDXLG8UqnDyBqtJSlhFQzI3FS6Wnfv+5NJ/QiltlxFgaNUMks4I6OpUdEVFU6
         z1cg==
X-Forwarded-Encrypted: i=1; AJvYcCWmwTnO5Fpo1OqL1+dFXMkxqGP6KWYzU/NTbN25XfWp7nS6nxTlpDv7f3q0D81X6qB9u72Jy6D1VNLDTdlw@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7WQZUUKbgivbUdIXdqmL7BX48lwsKasFEBWse/94TfcM7vWtI
	td9MTn/MT1qKrfdRvQzXOippWhYlf3EUn5D8gEzi3jQKLRXM1IlGw/9CL2+5sdbSbSvPgQrbsnB
	S
X-Gm-Gg: ASbGncuoPHEE4FmJ9zorhyM0IqxMaeMbqWAGpD+YF2yYWGhe+Z1EmCW3+i0n04mrl/u
	NUjAxKl+yKbwQcrDIQyR40QluhT5ucmpXA510Nuec7B5vWqbEbUynjiUqeH3iqZgF4uRL10jqrd
	xXmCDUkgbP2p+VoOExpvBaY6myg4tltGnEp1UMeee1QYep2K9wy9zu/wt06b4lzcDASjFSOzvnQ
	TmsJYKuqB8mSm/G0wpek8ms47T6Y5M4ueuUbM1Rl0qD7/rTu+8OpfVirP0CZoprrms93BSlh0Bl
	Bx9A5OtGG2vdwvnru9vKRXP1EFRQ71kOIa1/tSP8223FCAo=
X-Google-Smtp-Source: AGHT+IEM+iSkjODwzqX6JmHzpZx5dFBa9V5ncsKe5tqs1bQnjwuXD+UnyrMlHKMZu+xQ4SanEW4CPw==
X-Received: by 2002:a5d:47a5:0:b0:391:ab2:9e80 with SMTP id ffacd0b85a97d-39ad174df98mr2492035f8f.24.1743074119917;
        Thu, 27 Mar 2025 04:15:19 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9b3dd5sm19503318f8f.45.2025.03.27.04.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 04:15:19 -0700 (PDT)
Date: Thu, 27 Mar 2025 12:15:17 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.15
Message-ID: <Z-UzRZybK1du6HYM@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull the latest changes for the kernel livepatching from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.15

==========================================

- Add a selftest for tracing of a livepatched function.
- Skip a selftest when kprobes are not using ftrace
- Some documentation clean up.

----------------------------------------------------------------
Filipe Xavier (2):
      selftests: livepatch: add new ftrace helpers functions
      selftests: livepatch: test if ftrace can trace a livepatched function

Petr Mladek (1):
      Merge branch 'for-6.15/ftrace-test' into for-linus

Song Liu (1):
      selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE

Vincenzo MEZZELA (1):
      docs: livepatch: move text out of code block

Yafang Shao (1):
      livepatch: Add comment to clarify klp_add_nops()

 Documentation/livepatch/module-elf-format.rst    | 13 ++++---
 kernel/livepatch/core.c                          |  9 +++--
 tools/testing/selftests/livepatch/functions.sh   | 49 ++++++++++++++++++++++++
 tools/testing/selftests/livepatch/test-ftrace.sh | 34 ++++++++++++++++
 tools/testing/selftests/livepatch/test-kprobe.sh |  2 +
 5 files changed, 99 insertions(+), 8 deletions(-)

