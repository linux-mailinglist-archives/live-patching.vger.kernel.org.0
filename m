Return-Path: <live-patching+bounces-681-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C59AA98530E
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 08:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A55F1F212E5
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 06:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033011553B7;
	Wed, 25 Sep 2024 06:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mymxVPvI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DCB15532A;
	Wed, 25 Sep 2024 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727246463; cv=none; b=ikFo9ok6gpCO6KlXS3c9t0kc0/UFbfYA5FnotUms6sXb8/0AZgLBVDJEQt9UuKroMM2r8U5teNqTEQ0ZfvlPqKAdAWbf/JelTWOywFNfhQbtUPjZ5MIS+9VpqrtSGisr/x+XKwv+vCxvFcGH3wCQty9N2Q/74FdDFedZ/+n+58g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727246463; c=relaxed/simple;
	bh=oKdE1CR2TXtlKVifiF/N3OXDdWQfUEcsyh6OwQNWd8I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XzJXayFU9ljAZh5ciGqoZeZkhpHYXWFb0k51OvRfGxPOugVcGBUQKQwDMmiJo1uOSRwzxZcg/Wkl2psI21CD0Z+4LaJMq7I7npArdCiEAJ2z+Yb9j3RGnE5//cg2PCfbM6Nbyr6i81chxFIXrsT3uZaorMMSA/EK/JBsX5bdHsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mymxVPvI; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-277ef9a4d11so2667701fac.1;
        Tue, 24 Sep 2024 23:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727246461; x=1727851261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o0hxVab1bP0hyYCSZlG6S6JhC3IfoftISmLiOwazzgU=;
        b=mymxVPvI4h+EKYA9c4IxgKTNEcX1SWzOa4E2sGW3lcvdKSdIYOYDLuwgvh+Qc5wz/J
         ftU+RZxQAqaRbZFJ55KcyufnrXF9J6uouwHqxoTMBBX1jtTM/f0f5xYZDTyXJzuvFA6c
         DQxbkhQEU9sLhqLj+s7LMBdZ1V1x1gqfhf6sP9f5nTksE2OBjUoLwU2guicvfM7O5boz
         sFOAyT22zX5wnVBawJwfX9jR8kKkwoFrvKCs7dRaobAmtTEbntGlwSHb/qeNjDZJUkwL
         SO28eeLqD6aDG6o1n2bqGwo9Q9J3pz2AbLb/4h5Gg5CrssJSzMWWX9pslYxLyn/chqTz
         e2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727246461; x=1727851261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0hxVab1bP0hyYCSZlG6S6JhC3IfoftISmLiOwazzgU=;
        b=CkH9i6/p3laS1/JekbMuCjx9QpkkwiwaLswFSVO/X9547Qj6fWxkD/1YBMSH7y8rKL
         iM7StjMdIDPXUEq1gb2x2cY25sR3OuRvvyo0wk3L3ONcCCDCJS/Okks4XjrdcBFIlv9O
         Ip2MPvc6W9zO0IqRBka2bIa1jJR304+1q2LocfNzsHqDwChA9CKq0ZpiawofygywcfQ3
         4rDIVr/DUPlcv9AqW41tiEfSpaUoUHozcukqu55BM7ujbnjYxGXd03E1CkG/CoXhtdJp
         lDJKt5SWZ8Lcyoacoaaxj7G3KV2mxKKBrpGQqaz3U/VFRsbXgy414uA1WhWf5Y7RQ4xO
         shtw==
X-Forwarded-Encrypted: i=1; AJvYcCUahcUe+mW+5OkLKB/l4x0Hu5Mh06iRIwcUg1LY9mf5iwoVE34gnIuaS08KCs+jPUCNEHuGj96vOaKUvzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPB+qdSpvPlMPT/t+sNcE47hlVL94v39N27kjBZqPpiAZ8Dpm7
	+/x5BGd51SGpTs1NGUHo+D/PWoyiM7itusoZ+pA1rxB4IJl6UzSa
X-Google-Smtp-Source: AGHT+IGgLVPkm3yYA/kxKuVJRoMApdf1RB0d+VZu3DzwBJvELaty3T1m3Zh4224JbUdKsMsOWjDTEg==
X-Received: by 2002:a05:6870:7249:b0:260:fbc0:96f2 with SMTP id 586e51a60fabf-286e15f7788mr1489203fac.34.1727246461320;
        Tue, 24 Sep 2024 23:41:01 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc8443e0sm2139578b3a.62.2024.09.24.23.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 23:41:00 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] livepatch: introduce 'stack_order' sysfs interface to klp_patch
Date: Wed, 25 Sep 2024 14:40:45 +0800
Message-Id: <20240925064047.95503-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As previous discussion, maintainers think that patch-level sysfs interface is the
only acceptable way to maintain the information of the order that klp_patch is 
applied to the system.

However, the previous patch introduce klp_ops into klp_func is a optimization 
methods of the patch introducing 'using' feature to klp_func.

But now, we don't support 'using' feature to klp_func and make 'klp_ops' patch
not necessary.

Therefore, this new version is only introduce the sysfs feature of klp_patch 
'stack_order'.

V1 -> V2:
1. According to the suggestion from Petr, to make the meaning more clear, rename
'order' to 'stack_order'.
2. According to the suggestion from Petr and Miroslav, this patch now move the 
calculating process to stack_order_show function. Adding klp_mutex lock protection.

Regards.
Wardenjohn.

