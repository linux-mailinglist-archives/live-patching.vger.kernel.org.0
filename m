Return-Path: <live-patching+bounces-1106-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E86A271B3
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 13:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6C573A1892
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 12:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F81920C037;
	Tue,  4 Feb 2025 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M6S5Plhq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6111DC745
	for <live-patching@vger.kernel.org>; Tue,  4 Feb 2025 12:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738671559; cv=none; b=H/Tf1+cv0MILfhlecBWclU6HSa8unZ5vXtDKhAQhZBpHo45eq5125hKK901Q3SmP6Q+Mwj5f1FAROnBj3px93vnNZtpWniXXGWcpLzUdNB8cNgsWrK323WOaETJ4rzeRtHYzshZsLbTg8dWkVtDi6b1uTWf2klnQ7WIA8LKly4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738671559; c=relaxed/simple;
	bh=Mr0FuXr8a4wpJsAAWx1cd2vNdWLqxjiJMd773NZ3+ck=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aMKAAeN86yRX2vHB3GmRFOSRGwBW/2Sca0BpUiQLqQ62r976AZSY8Pm4wRbaX4ffwYgzGc6inJG7QDxV0i0tbAmMH9UJGu7CLTAauTL5356ISoKONu4TwOoYoUvB3mokGIVHFslyboFZH/sDuaqBM0ZhNAaGYt3t/9gW4/8c+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M6S5Plhq; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab2b29dfc65so911747966b.1
        for <live-patching@vger.kernel.org>; Tue, 04 Feb 2025 04:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738671555; x=1739276355; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UsezKdeSKwYZj2Gc71tZVnHA/twO8FklaekB/V9xp+Y=;
        b=M6S5PlhqzSLAn2A2XRvJuZHKz7Kg6UiEfwfJxjK8nzm5zOLzA/ZApZSDjay4D9QEMi
         6+XY5YfCU6fB1NLWdW+VkIFxx09Pd2kPCJ5bEolzjDz2ppIMrILQt+lZkx0mp58uNXQO
         xh7mTG63XeQEKAXLRgaG9PURtlPJubS7o6+VTInVcM0bIaEPFd5c8j/ZcY0oHqlc7gTc
         KyyFR5EVSn+LU6qRJRrr70h2gDOPdMPHEFpAdji8b9Z6utYXHDRVgdD5h/KNiHHL8j3y
         mf6iNfJb7qQvIb9jZbX3LXP+myBKnXP4wqDjCDJSFP3rB/iYyaPhi3iGoVEHBAUI3jrS
         9pOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738671555; x=1739276355;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UsezKdeSKwYZj2Gc71tZVnHA/twO8FklaekB/V9xp+Y=;
        b=hXriWPBFo7WmFLRwFqz4s453vNAzhgbrVICk1He7azdIkrhqZkHElFiVRuP/QJ56gP
         VbBNMujx3M0oFTX9+ujt0FOOPjgYagw80MkP0hRJE6UHzAmT7Gf+ftkX/2XqJVni0DbX
         7YTfUS6+S5dhVnW/RtVgO0S4WL9Mn0G4sifAk+qUN0OK0LYQk/HGnUBZodnsqsIV87Uj
         thUzL8tw8y6OA0qcH5EyQ0zcxRbfHThAsWDUk/ve5Adr5R5mOaLP/K+lC4epHHt64YGC
         SGw2P1F8hQAyDLkSqlyRHqDWrzihYydtOmOLnpPLtLgHoEzLnzfByX6VBhF4Q1xjb8N/
         gMgg==
X-Forwarded-Encrypted: i=1; AJvYcCXES2vYP9Sulj94m4wongHpl8jzd580mu35jpSA+OpZvGnoqQjLWU4eLYzjOLwkuYNaJ3fQqDSmnhf8TofT@vger.kernel.org
X-Gm-Message-State: AOJu0YzhpZUW1LbMWsfLMa9mLFxXURKVpNlOTzAm1YrcMDgPjXpJY0fy
	nCgv5fVup1KbU+H5akt+YQ4CKbZD2LLSqWpn1/VGssczgzRDur0efgFMSGLyJTMfiFv+OdnMx3f
	/
X-Gm-Gg: ASbGncuNSrpwfnLDrl9O9x0UrA/WdiI1RTC3c72LR5pUtyyJ8wGz24W49/IzmQE3Nej
	TqLdzX8t+Gpj4S6XJnbvBxnJuZxRJ06fm6O13ZKXaPMiArhafdl3QttR3N+DDy/zd3NTcuiRUBy
	NXxesc2E4zng/6clM9yC/Rh6K5TQwoXjkEjJ1YnqlD4hqKBTp2pnvRhRbaiRFNGoj64uzydRxdM
	sfz55OdSdkoFkzyNkpR8QkK7+vmaJfcGnTdMJCVSNca+vxh45lur12Xr2xt+b9qA94jmxhxVgqK
	1vpMBT94Gaz1KSIG9g==
X-Google-Smtp-Source: AGHT+IEwqcYpYQX3qCjOOLIQKrrBSa5mgJ0AY6GyMzMPuN6SNgZMqvRW2Tw8lzVKFa0aqMaH3AapFQ==
X-Received: by 2002:a17:907:9691:b0:ab6:dbd2:df78 with SMTP id a640c23a62f3a-ab6dbd2e39dmr2863868866b.35.1738671555490;
        Tue, 04 Feb 2025 04:19:15 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a320ebsm911008566b.154.2025.02.04.04.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 04:19:15 -0800 (PST)
Date: Tue, 4 Feb 2025 13:19:13 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.14-rc2
Message-ID: <Z6IFwZwdjFGvpYMP@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull a simple fixup of livepatching selftests from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14-rc2

==============================

- Fix livepatching selftests for util-linux-2.40.x.

----------------------------------------------------------------
Madhavan Srinivasan (1):
      selftests: livepatch: handle PRINTK_CALLER in check_result()

 tools/testing/selftests/livepatch/functions.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

