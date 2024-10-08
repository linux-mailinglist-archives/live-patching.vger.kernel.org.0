Return-Path: <live-patching+bounces-724-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E33EE994192
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 10:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F78F1C25EC7
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 08:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DEF1E2854;
	Tue,  8 Oct 2024 07:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+NWnTWx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8651E0DC8;
	Tue,  8 Oct 2024 07:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728373939; cv=none; b=do5NkBRyEUGP6e/wzFG8TaC67KPb4iBMWR/Vgu0GVyEu0CsuJY9TCJyP/9XNP4ut1s+gMLBR1pTbFLtaRkg/lQXIY1J+ahirlvF3o6ZkZlgLmXs0+yuwY0SgLjb/dy9NMr7NPXjUCcqUi7adWSzjov37hGPqJP8d3je6YsCPh3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728373939; c=relaxed/simple;
	bh=uZQOH51Z5Q/YEo9lLRfE/LXIWkfrtpFeL7duVv6kcOw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i4m/jaQOH4aRmYKCbNP5J9vPShwNd7+XAE0hewUcQQ9hufO+nfKZUMgJrPHM7u7TZE5tYoYOaepdf15y0MxG/AMPHukf4SR7IxecDAub0nqzd1+M7LPRTiroR4ZOaILF1lTl1CIfueCTtSR33SGnkd8F3OVxvDrd5kVC8eQG5FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+NWnTWx; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20b8be13cb1so57146085ad.1;
        Tue, 08 Oct 2024 00:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728373937; x=1728978737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwfGYVVAdUDGX0Q/LIwa5OSrJvNr6BYXiWI1D2A3OgI=;
        b=Z+NWnTWx76cQPtFgPXyN85IgKCOIffXShPSNdzxobcnuqDHabqshA31aJW3A7SvBD8
         EMNygZH+lNti044aQ4LuMW0Ar7YyDFm/zfjoju/Jn+g87qFsPq4iMqas7db4UlXBBlks
         gv2gyrj8wA5j0TzbGB1H9zmzr0WeRTN6/wIymnomwf54VqTlugMOS03pUSrEdNHF9Xgf
         Gn2GAqDvP12WwdBIjstQEIhpmq8f7sm1MTw0ioWgt2381avF6qOLeP0zHMgVYAezGMaB
         4uQZh2JnY6udnottHocmdzsWtxkKLN5ldfIL4xRJKIIWG1C5+jF54gA5x9nt8//fxQqV
         gFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728373937; x=1728978737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwfGYVVAdUDGX0Q/LIwa5OSrJvNr6BYXiWI1D2A3OgI=;
        b=lfmmr3ZbBcskCmWe76oohm+aoyfMUWzObY+EgZa21vgnDCk0KDtVvBaXS+FkP1TILH
         z+gSNEnE8JxGsrU8B+P3mnRa+8OwC9e/6GhfQEpMo0NPmK24fgSAmLdlCQqNhSKQFuqe
         yYhc6ErI6Ub93kX8H1CscOo5Oo7egtajRkS2S8KKqcXXfAlX5bgGXQqrlxJ5FKgADt8h
         AoNq93fMFL/qDjnjIDZ+E/FSYRSUxNC64KEOYIHSk4wAYItnVxuQ4y7ca54yFzeKuM0z
         3CvvvXMB03dkbbtRtEDNN0ZgKwI62AKnz2uojloE6k8JpBT81/SMqvVOo4U2Nu4rnRG5
         UQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsNRK+uDwJMfIZWynKFPFkUPwPGhUhzCyjrEkMoxirc51JdZ+gNg/3jdq+oT60fpU5Qul1pzVxd/UCeK4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/5jO4nZ+dnWh7APcj7bzgLyRmWhzaIjmXRAd7KKJm3u1MstWt
	FKeSWGCmcmq6/PgQubI+1R8jBQUD6VHY0AfZce+A79hjOu3tKSa8
X-Google-Smtp-Source: AGHT+IELxKeCyhkiFqYRUlHSfvgaOoG0w1TEyz7yAvkv+JcVwwzt9gwoW3RJi8zHqy2Gjc5rf/V2oQ==
X-Received: by 2002:a17:902:d504:b0:20b:861a:25d3 with SMTP id d9443c01a7336-20bfdfd9423mr249444575ad.21.1728373937407;
        Tue, 08 Oct 2024 00:52:17 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138afd1dsm50497195ad.36.2024.10.08.00.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 00:52:16 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] selftests: livepatch: add test cases of stack_order sysfs
Date: Tue,  8 Oct 2024 15:52:02 +0800
Message-Id: <20241008075203.36235-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch add self test cases to 'stack_order' sysfs interface.

Reuse test module of 'test_klp_livepatch'. However, some module in test_module
have '.replace' enable. So, I set the replace value of the stack_order test 
module to false.

Regards.
Wardenjohn.

