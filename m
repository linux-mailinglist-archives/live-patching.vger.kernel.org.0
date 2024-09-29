Return-Path: <live-patching+bounces-694-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1663989607
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 16:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E2671C21420
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 14:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F3317ADF8;
	Sun, 29 Sep 2024 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QiJr6vqx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6CD152790;
	Sun, 29 Sep 2024 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727621035; cv=none; b=tD1Ca6uXhrP77YKZIc25+kNk50YeizuEUHoNRXQocy87L83/AbD95wFCwjaPzVXmnIuqYprser41b5g8yCI1z0kV+1r/zZ6kx5poCiWI2wha/xL9KTsmOZjGtAnQoRy76FfmUKebGhDI3gaoMXP5uw56b6J1bXPBKDnCBRswWzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727621035; c=relaxed/simple;
	bh=8rTyJxAfO3B85HP1kg6hf/axlxAl4Lj9VgohmMrNerg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HqhvE1+PmubMjB0mdw0mCNsCgLcTlaMRoHOlKi7W0bCegdlOUwtIyr0/7DCpmMuCS4nwSJw9ugLHpGRdNPxqq4+bxvMHtvB9CiTc1VLyXQwEU+Kppf4BAO1fl7dArQlAd3d8EpRwIKD/dbcTrTZlQmzoKV4XvD7UFC8fM+I5b8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QiJr6vqx; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-206aee40676so29465795ad.0;
        Sun, 29 Sep 2024 07:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727621033; x=1728225833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KKH0wmfhXTT6EUqQXpt5WFcS6xMVt2z57mqdHZva2MA=;
        b=QiJr6vqx8f5Kc9FUVP5Jf6BBuACC598kJ31IgGasuGTnS8LZcU7gNJGLwKpBc5JIPU
         VB4mxuurz6pSTdaGirFJdiDNqxvX7f4Vh6+uedQ+DAmG5ppnm/DmygvWWqUMF3HZzobd
         PvOfwPBSZPKDWdt08idVkUth9Qv8jow4gOlvVDk6vPiSedF0iZOVLVkp6EotMLav7rSP
         CbHA+mSqL1FASwrjyFiMRy3pxRcSVRlMB/WcCXxMa2vkfmtolvhBieFSm6oECkxXpubr
         G6L+emOqoMEbCk8tIwB6dPPRNnByIo5+tnGSRDD/NE4tr9ilJzydJZSo4NjpNIkl2geS
         AXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727621033; x=1728225833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KKH0wmfhXTT6EUqQXpt5WFcS6xMVt2z57mqdHZva2MA=;
        b=st4PjggpG94N185S9uEXkjHu1PfKpGUlVqyCX5kULDF+dxHUsqWL+09P6VpxLIS846
         G3f7ivIo8iDeVk5d2ZjEpP8AYgymioqT7MMNFSBvlgrtpn+WmpmOP46i9hJJqvK7VMZO
         HaqgAk4XtkiKKBZzf4iK7VQqolAO0XIRLVygw28P50oJZ2B7vspM5moEC5IQG4AKyqtY
         BQbboujHrbe4hCNSvNQ5j4SLuJ+J2ikDJi9XLiS5hf8p8XQuUiWmTWouUdDBurugYCO+
         wm7WQickC4zogasUbDDMUb/wXJXnIdp5GljeYwZDABKIG3mhfCV4mkobEptvA0nR8QZz
         5/gg==
X-Forwarded-Encrypted: i=1; AJvYcCUg1EG8yq7hBpYMx2f66A1x9Kj/iB4Ydc6kv7798+qAkIWuNMec7dqvlnruK9Hs9w46Uyb/Kvbb0FlBTSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ka4XmTjEu3mrv4z57VOvtUi1tjuPDN7XOrBUBkgf00idmn2R
	B7DHFpU3TOw283P4P3Il+SCVqfHjCeWVJwtdHFaLlDWBRDKHG0ZlVZ6WuVcE/SM=
X-Google-Smtp-Source: AGHT+IHOZzT32HXSPX5UWq6ATXCUYK7NR4ZUJ/RlW3LAT2wFc6oxGYQj9KCI+J947N73+E8HRcKcqA==
X-Received: by 2002:a17:902:e54e:b0:20b:5aeb:9af with SMTP id d9443c01a7336-20b5aeb0a63mr91840025ad.22.1727621032880;
        Sun, 29 Sep 2024 07:43:52 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e0d5b9sm40620625ad.174.2024.09.29.07.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 07:43:52 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/1] livepatch: Add "stack_order" sysfs attribute
Date: Sun, 29 Sep 2024 22:43:33 +0800
Message-Id: <20240929144335.40637-1-zhangwarden@gmail.com>
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

V2 -> V3:
1. Squash 2 patches into 1. Update description of stack_order in ABI Document.
(Suggested by Miroslav)
2. Update subject and commit log. (Suggested by Miroslav)
3. Update code format for some line of the patch. (Suggested by Miroslav)

Regards.
Wardenjohn.

