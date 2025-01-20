Return-Path: <live-patching+bounces-1011-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61193A16F3F
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 16:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE95E188264C
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 15:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCB01E7678;
	Mon, 20 Jan 2025 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uh1MZjHv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B922AF0B
	for <live-patching@vger.kernel.org>; Mon, 20 Jan 2025 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737387031; cv=none; b=Dnspnu1GJkcdeUHiLzjsYm1brfUqnWPZCLoiXvAM+/huUIzOfw/0xOXCEkCKd6UrECuVNYYZyxWZLh32kIoQI/S2pIDN1iZAn0c9VyKpqR3m3wAnfvI8Rx5SnowyliX2oH2H0BGuPLPO/W2Z120Zf09U9iQnmD37xztLVL1j2X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737387031; c=relaxed/simple;
	bh=/EVjmqsWnd96GA3fdZF2iK35jKE5yEZNZ3+dMALVT8k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fG03Z5p+1GhwvISzp2IScPsONn4eeCBWHwvps2AasGI0kJoIauao6b+Nr7iuXkLe3KShOi0fOJBLhDZYE6CRasR6bxf4DD4Gxoggo5pPILacaFl7LPBlIBvUsz3qzmx8+oDm33Ah/Stym0AGNRw8mETo+d3u21KYJ+lUIY2DYk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Uh1MZjHv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-436345cc17bso32970655e9.0
        for <live-patching@vger.kernel.org>; Mon, 20 Jan 2025 07:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737387027; x=1737991827; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=egMhB3N2Rw9V5njLefv6j/Qf2GZQrYGzm8354CwabJc=;
        b=Uh1MZjHvNQOsNeZk5co+yOkLU0A9B4x0fSHoebI26dusKSbkERVFxNyYqu4F70lI3h
         hn/dugh145JXz3WcN918AQRuxZPsAkWdHWmbNN0dlJNAxYsieDPjdjMr1ha8R71DBtZf
         9rW8ZOxl4KrQAD66ou0zRXqS+rz+pE94XqxRDY74r0Xa2RBuXHLPR2cUmepuTsTCTVF0
         xNxDhK5JIZ2ACBny0fqPnoDTfaI115M9h2O6+VUWykFTGUkuvxOobhlrevVVy6WiE4sD
         Af53ZV2CIb5SP2YoiGtEuKpM5Jk1DfMcJpyQSNN7QyWEUYLPZg7okAMydXELR6mP6a1a
         J7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737387027; x=1737991827;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egMhB3N2Rw9V5njLefv6j/Qf2GZQrYGzm8354CwabJc=;
        b=wc/aw65mjI5VbV7o0Dgm+4lZfGldcKIRqI8HDH/SqDsG6vuLX8X4lbzi9e93pKjVkR
         CEwSRH5gfs52/dXME44BF3x2+TvWHt/vp6bCD+Oh/bMVHFBa7eSYE1+ZQ8loQrcMUAmJ
         XbIErhKwXfOAfOOt7mNZeqfdjwI+8z09FDyKO4zuXO+wAvjz/iRfMfFrBBLJwJnkMbQX
         Mf82RlJRgPfuUB9eGWocmJbuDs9Q3rF5wqQ+8jJ4c4avSPjp6FqecLXey7iOU7jDcKAz
         ycJtNCFGswtK8yqLotH/s11vLSCemdUsjoZg5zGG8BaBS+tc7IvmCl3GoEkgj/R0tBER
         0Hig==
X-Forwarded-Encrypted: i=1; AJvYcCVzdNyqp6ZcKRQncS7Z43TvVc039+nHyeS5/QkmjatXORmk96j3tOoztN2TmqqGQRNWMiiVLfcwkJtcUSeG@vger.kernel.org
X-Gm-Message-State: AOJu0Yzan27RoFo4liKnQVy/SVyu6guBWJJBgM+/pol7HQBlFEMvHIfE
	hSW/IVMSEJc+eOouxfENYFFyXhO4b6SKXLahVX69GsfONdC0QU8K8nwWWl+7+aGdxgsHNp+h8mC
	l
X-Gm-Gg: ASbGncu2tOZWJTIP73JCtQHZD6Bmdrgjmj96dzDcDLufCxuyzxHFIlrtSilytOQCevE
	H/B6fCVdxPuBcvU8Entz9yqGM96yWHxHmfT0WhkswXRR24rTCfnr+v2+R52k9mjHk+62Ne/Is4w
	+SWyOHjJrzCisHXg1KWFzeuMgTrb+4FkGumeGON6Aa8PiaC4+O+DvUbUHmd5RksL5Yc8MhoHk4w
	abVOZyTGna90vBQtHdBR1bIFHhcF/VcmIyaTDl5geVzdlkg2Km5lxGHOwSkFQHDrFIYaFc=
X-Google-Smtp-Source: AGHT+IHvx+OdnmSr7btWugmYvV2hm+eDSftatsNePNUH9RxMXT57i5VFHaso7ytj5dVq7ad0SdDOqQ==
X-Received: by 2002:a05:6000:186f:b0:386:373f:47c4 with SMTP id ffacd0b85a97d-38bf57c934fmr13677956f8f.49.1737387026810;
        Mon, 20 Jan 2025 07:30:26 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499b28sm212160695e9.8.2025.01.20.07.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 07:30:26 -0800 (PST)
Date: Mon, 20 Jan 2025 16:30:24 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.14
Message-ID: <Z45sEOihzNaOqGwO@pathway.suse.cz>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14

==================================

- Add a sysfs attribute showing the livepatch ordering.
- Some code clean up.

----------------------------------------------------------------
George Guo (1):
      selftests/livepatch: Replace hardcoded module name with variable in test-callbacks.sh

Petr Mladek (1):
      Merge branch 'for-6.14/selftests-trivial' into for-linus

Wardenjohn (2):
      livepatch: Add stack_order sysfs attribute
      selftests: livepatch: add test cases of stack_order sysfs interface

 Documentation/ABI/testing/sysfs-kernel-livepatch   |  9 +++
 kernel/livepatch/core.c                            | 24 ++++++++
 .../testing/selftests/livepatch/test-callbacks.sh  |  2 +-
 tools/testing/selftests/livepatch/test-sysfs.sh    | 71 ++++++++++++++++++++++
 4 files changed, 105 insertions(+), 1 deletion(-)

