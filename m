Return-Path: <live-patching+bounces-735-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7A899A740
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 17:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D3601F23EC2
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 15:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CED31940A1;
	Fri, 11 Oct 2024 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ef8+JbD8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA2F39FD6;
	Fri, 11 Oct 2024 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728659590; cv=none; b=ivfHtD80VojuSpyte9bIMln3uTRvWm1W+65z4/JYOfxyyOQgGQ++9N6rEF9cdqztOqp+A18F6MMRugMn9xyoVddQiySeHApE6GZYWihjaCXpcXqZ1OFb1zwaq3TUV6a+/mGtNQtimrhwF2C/0cOWPcKVmVlARFtTXcpZ7ITdDfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728659590; c=relaxed/simple;
	bh=2pqzdtzMtmc2SryWUwWvnSvvv8OJzUX/2lJ1utI74cw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bJ50uNxqleYMZzcbLs/goqvGd0UdrTgwcOu2IXHYlR2OESYeDmxkEzJ5gdC7bn4LVnbl/EfQ4w0HSvBSyHR7LUQPjYxjvsD9dFMdMVEROPD35hVc5mZTZwcsl6KWR1DycIKkUGCn6/z8Xj//79EBf80aKMCs7WwheurmheOQ1cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ef8+JbD8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20c9978a221so14957635ad.1;
        Fri, 11 Oct 2024 08:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728659588; x=1729264388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2pqzdtzMtmc2SryWUwWvnSvvv8OJzUX/2lJ1utI74cw=;
        b=ef8+JbD8PFYjVvaaz4Gu9socPOaKG0NdnjWd86btjW2Y+RdbbxP8EpiOwvuKccZ71c
         NWt9XS6pocJcPAoSLg26a+kprDU+Qot//Oz4L+AStN6Y1VsEjtwlF/jsRW9+yvfqhqzA
         /5IRhmL8aykK4qe/g4G/+XTr0IpDtC3SSgpfWM85oq+zAcylgdisnLFfUrTqfAmH2BRr
         PuM6wtWyjSHR4aVY3Uy3Le5c3Vq+usBNNOHj9hsulOF+a/ov3zTiOBy1W+k53GGvp5fA
         T5twUklgtA2zaCmq1PJiO5T0XrRAMfzhXxCBvaPBBr+lZyOi8975cuFzLi0rAwIPsuSC
         Zt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728659588; x=1729264388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2pqzdtzMtmc2SryWUwWvnSvvv8OJzUX/2lJ1utI74cw=;
        b=OQVovaJn7wyyP29isUCBfyjYBVQbYINvR2Ro7w7O2DJhA/1oDoyoNGooOD++KRB98r
         DSSPRVwR+4nS7q/rbO7EA+VJHM8y4hncI6uMETZim8+etnmYbD1cgFgGN3aEWcOfOYK5
         XB479STDqhB7S+DSgy6/SdSThOcKX7BRZyafq4wf0Gpi3TNpsvOCOQkO02puVDKQzZBp
         jGL9admVfbIkF5RyqrTnCXhFTKE/Sz5K8LekYkEZpLma5Lo+OzAyiKtKZBFgyXr5HaQY
         AY5YvkySCzJi9s2sHqmzsHFZQrYO9oJJ72EZKWlWJq2JShYVxWmOhTjdd/4FDfZMyuQA
         KQ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXo5sKcra22YLjD63XQ5zBbj6EecGAgVnOFLCsv8fYQVqOuCjnSWOnal/ie+Z7NIE42HjPrrq0ljioxddA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwa+TLUKf/vG2fQw8COHrk0bRoh8RkcYLC1xHUHHGupsCGLvjN
	iBNRPk8DoSvEZumRTFc77kHAVWLFuaMoqd6Gyg3IbE65hKb3upjG
X-Google-Smtp-Source: AGHT+IH08WgVsz+EshPtwqpdseghUfqJ6a7drhVnkLqVl2nw9IS9nYsJyLlB2UsTrII6j6u2XjkCsw==
X-Received: by 2002:a17:903:22cb:b0:20b:ab4b:544a with SMTP id d9443c01a7336-20ca16c8dc6mr45397255ad.43.1728659588023;
        Fri, 11 Oct 2024 08:13:08 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8bc48f03sm24457545ad.117.2024.10.11.08.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 08:13:07 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] selftests: livepatch: add test cases of stack_order sysfs
Date: Fri, 11 Oct 2024 23:11:50 +0800
Message-Id: <20241011151151.67869-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch add self test cases to 'stack_order' sysfs interface.

I found some existing test modules dont set '.replace=true', which can be used
in 'stack_order' test. So, use the existing module for selftests.

Regards.
Wardenjohn.

