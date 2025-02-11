Return-Path: <live-patching+bounces-1147-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34078A30390
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 07:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BA3D7A27B8
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 06:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A88E1E5B83;
	Tue, 11 Feb 2025 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkOMYOqC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757501E5B9D
	for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 06:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739255088; cv=none; b=Tf2lDoAIk4Y8brkqm12adCERf4JwOZnmZnV2VEDK7DWF8CehmOvWnIoWYKMGH1Sgc+X782UqmomQ8NIX5jedGMlzEeSK713qB5eMXGi22JCW/X2VG8uMpS5Y/lo1WBxfHr5NbZhnMyL3YM/FfRGkfahAEz9/wsC6PElSiHLbb+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739255088; c=relaxed/simple;
	bh=dRUY4XKtuxk0mt2GsvT1xcB0dnL4SA3K2K3aTswKg+4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jjneIm51w9CbqraB6sLn2ON6TLvvWFcOuChzgS3ZocXwQ0Us2u4NN+7jPZW3r0SbOiTVyOTzTZd3OW96tcY7eKLpPP1P5+tDNaKHqGokDAdi63oe9D9Zxv0qpIqMreDE3gfrHUOZLybRabfc9NuQ2c+52Y4Rt+sD0GB1bYfMgls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkOMYOqC; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f44e7eae4so84326675ad.2
        for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 22:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739255086; x=1739859886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RWBwZApSRHT20zKr8aIYdWiQF55JVJLJihTI6dCVnLc=;
        b=RkOMYOqCviIaubuWNb5C4OORF+pVlwBe7VgovPCUHZ0zoJOvCgUhOQkk34GAs5Vr08
         yBl2dV7qjh8w6mLaw6/Zn7k3uE/jd7sLHEzd8QLpxFJEOALBB2+UDTC2yiUguL1z0EWB
         nEA+2xL8u8NRNcg+sM5sZaq4ViAz9pV4ym51R/xQS+/0dckEJyQgcVA1E8MDSeEiW8KK
         yBZIJCGz8QCrL1sfe0mwzlFwGaaq2YDJ5LWdnIuM7l+RWhDc7DnKrIlJViEa5Mq8HUBJ
         D6CgRafG2lzZ9U/9WQ1GGHxBEa6xI6wi2tWLHXYROWlVS3tyHnSpd3C1Omu3t0D9MBiC
         +9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739255087; x=1739859887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RWBwZApSRHT20zKr8aIYdWiQF55JVJLJihTI6dCVnLc=;
        b=BSTb1xqzgXIh7IHacshMrAJLbVUOXZ5kg+bZ3PJ/L3UdwGTu0rYwhYSQH7vvGYdzo6
         jmX6UwvMHpQHQg/hwjL4oqhKULHWrT+sZD87Dcu8bALoyenEPSKutsz8c6FJj4Bxa7AO
         ZzI0ODjZWH64fXDYqeuldSki83uiZeQCEkR4X6ONwIPwK10419l/k2ZMHnhj6NiQGQtQ
         LCD1OgGpSbBfUgocom2URAxF9RFiwUqOgABlRNt703H45r+YdVhCDNHBu1tbQlzGLIPt
         81qUon1ocNR+oQxHHhCcQCuHGZys2hjjrn3BWurM2UrONg1tco7fIESbadEAb76IpPA6
         235A==
X-Gm-Message-State: AOJu0YwmMKHXQ26zFpdynUCUNkgiiFAaRAxEoBG1xcYZVnZGHYmhJfCa
	J8cnb5Vu+SKVu8dCDC/mW1CuNMZtgvimdpwfp8F1trpJOjpQSVfm
X-Gm-Gg: ASbGncvrm03GKIJsx7jFjL6S9I29GoUWhX5GcZJugams+OrrXuMMTNReznDJH7R4sHv
	ZyVaeZyNHFv7tX6jDUvbeZmAUGkpRqxArOmxFpDTykPHow0I7kb2s5Oi3m2/YbLmfKdcDcnOUXp
	bU+EerdHVauS3GRjl4hH4aDmrSOFCP4xVZgrEIfBAV3/mYCVFCG8Bwg12z/SRiDf2H+zrG0GcqN
	tLmr3OQfbkJ/vJ9D+Lu13zyhpBepFHqZ22XfH4x16Rqrz7N/I1uPmEoizzPLaCAEezZfOTKwrcr
	UJSKeMIXq59s3QnGZTBIUHbF2WwB/qfxtEvjdgs=
X-Google-Smtp-Source: AGHT+IEEf0yNIL3Je1wdwnSS5rgoyTsqiM5WPA7iiN+hDhNxcrGZCLvUD3UvXwwb6iWtHNDETF7k0g==
X-Received: by 2002:a17:902:e802:b0:216:56d5:d87 with SMTP id d9443c01a7336-21f4e7637bamr296103085ad.34.1739255086579;
        Mon, 10 Feb 2025 22:24:46 -0800 (PST)
Received: from localhost.localdomain ([58.37.132.225])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f363df2b4sm89016985ad.0.2025.02.10.22.24.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Feb 2025 22:24:46 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 0/3] livepatch: Some improvements 
Date: Tue, 11 Feb 2025 14:24:34 +0800
Message-Id: <20250211062437.46811-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  #1: Clarify klp_add_nops()
  #2: Avoid hard lockup in klp transition
  #3: Avoid RCU stalls in klp transition

Yafang Shao (3):
  livepatch: Add comment to clarify klp_add_nops()
  livepatch: Avoid blocking tasklist_lock too long
  livepatch: Avoid potential RCU stalls in klp transition

 kernel/livepatch/core.c       |  3 +++
 kernel/livepatch/transition.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

-- 
2.43.5


