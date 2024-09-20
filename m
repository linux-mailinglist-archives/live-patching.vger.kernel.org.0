Return-Path: <live-patching+bounces-668-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0154F97D34A
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 11:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86762282706
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 09:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE760137932;
	Fri, 20 Sep 2024 09:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zv6Qpm/k"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7275481AC8;
	Fri, 20 Sep 2024 09:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823072; cv=none; b=Kof0BsQUd96W7GXKGwOBVOnAKSa5Ef+Zn8aIBdCLpaz4ZRfT0W/r48QM+uPNdi5WEDkXCJpRl8dk3qZOuBF5armJf5G1NR2last8weL6ELUHUQA/l3yRMIKA81rqF8l0WxAdGnZiHTSRi/jeVH9cD2ksvYMu+6NRYXi5pc6Xn6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823072; c=relaxed/simple;
	bh=xWl3glfa+77O2PEoYwclwHdUxLwyrlo9U6k2GXGC/AE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YU8WyKkkVcyAZ3Ubc/x5/0pQ4jBpQlr6RRuVf2KNC9RqSo2nytnEvib4od9ALTQeUMf5RIatsOTSR/HIxRK22Udk+Rbx45kT2jE2VivwKcxQhFbAhwPaS4nPmOZGK3GnTg5/hZcH5IVr2+/xLU/I1EJ5798LF19i46NiqRldAyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zv6Qpm/k; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2068acc8a4fso18414175ad.1;
        Fri, 20 Sep 2024 02:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726823071; x=1727427871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=780SsjLKTyN4z/bv2hI5xqQ2gIRVMpJg4AqmXrMJpqI=;
        b=Zv6Qpm/kIHWnyHxsTseDly249WDhNeXGgEWiWyBfK72DgFX4LgwXx/D0pWjqmD6ZUt
         jlK1rC4z3GjT4e3XY18rQD6MP3lLOfgLMcdJx179AKYjMM8AF5zP3OheU5azeKWwltZB
         Vxlo+L4IsX3M6tHM8dCQRMfUpkgWo8fFzU2U1bAodgGjvd5oVBaCKYxhuueoAcf0F5Vu
         uDfRT4/R1A8GbL8MU2xgEVqFFFAMWqZDpga/7j8puAIZzregD+txj8C7L+AAfHpgUf67
         xTCFrjSp3WxtDu5sBoC82RELnWJkS3Kxj0PKpMoZSMvHuihToZ/tlHi98QWnoNwusixW
         mgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726823071; x=1727427871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=780SsjLKTyN4z/bv2hI5xqQ2gIRVMpJg4AqmXrMJpqI=;
        b=k8GWeJmFENTIHBoWIBA5AesJvP5WTicYmhIAK5N7rq8IovwbSz5icyaYv2mo6PjKJk
         f/nzxtaC9kr9fp7nhXPCUCyyRG/3ubPZcLcljgHc6I7P8AN8dZ4gJnk97JEU1tWMePy0
         X94a/feyJti5TTk5wC9t71qwefTEv7EbARxoof8bqUrTvnJVul/fFEJAX+d0lmMFO/gV
         tIbSujcoT9GrI8Kl1qX6q9uJ7Pip5+stDcGn/aLfJgYgOeQSwa9/zE1nqbMG1NPVHz2b
         t8pWbQeyFu5izLfpM2LaVkIeEVRJcm9b9h2Gi2BhQbRmL1G8lsZ2AZUgXyxSVzNW41A+
         Zebw==
X-Forwarded-Encrypted: i=1; AJvYcCWG7rpG5Mb3ZjEL7a8Jkq5Lu1H0vkUvcel3ZYjmud3YJML1FWw+rVi9/cLaVzwwPfUnpez3X+wWQGS6x/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuDMUlXe3wWJzHoyShwzVBvMqa+P0h+TEVeL1G2BsqumcR5Pz7
	kt02B8PACD+spwIKWXE6PCjRUHTNwiRXsXdIvVCVudE/ouCcKxCi
X-Google-Smtp-Source: AGHT+IE53COnOVEaKYnO2R1at+PVph9TPDE2aS9miHsQp/nr41PsWf30JiTDULEsADiPuPKBwzVM1g==
X-Received: by 2002:a17:90b:2808:b0:2d8:7561:db6a with SMTP id 98e67ed59e1d1-2dd7f4604c1mr2703052a91.22.1726823070698;
        Fri, 20 Sep 2024 02:04:30 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee9d8ffsm3483881a91.23.2024.09.20.02.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 02:04:30 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 2/2] Documentation: Add description to klp_patch order interface
Date: Fri, 20 Sep 2024 17:04:04 +0800
Message-Id: <20240920090404.52153-3-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240920090404.52153-1-zhangwarden@gmail.com>
References: <20240920090404.52153-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update description of klp_patch order sysfs interface to livepatch
ABI documentation.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 3735d868013d..14218419b9ea 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -55,6 +55,14 @@ Description:
 		An attribute which indicates whether the patch supports
 		atomic-replace.
 
+What:           /sys/kernel/livepatch/<patch>/order
+Date:           Sep 2024
+KernelVersion:  6.12.0
+Contact:        live-patching@vger.kernel.org
+Description:
+		This attribute record the order of this livepatch module
+		applied to the running system.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
-- 
2.18.2


