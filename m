Return-Path: <live-patching+bounces-342-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B02901940
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 03:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D0FF1C20881
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 01:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67ADF17C2;
	Mon, 10 Jun 2024 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6CbGHhD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1491E628
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 01:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717983237; cv=none; b=nL0ELr8hqpC8ijSSZS9MPzy6Q6Cb6Ap2H4nomSp4LP9Y8IJwQF8SSCQvrjKHuu3yxA+5vPXC1OMEj9RyG188Z74oLkvuwBlfhyaTkCHulIZGlYzHcBuXHw/XDSbTSI1S7EZGqSdYeSmr7FdBOj2Lk5+md+/lOSIFNbeJjy4VDxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717983237; c=relaxed/simple;
	bh=1mPUaPjWDSZSWsvsvpXMoiCezk/rew7OcFFmwkYAo8s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=egDfxYivaCCPMGtiBuoVGp4sxZIdCGEMCTZppa1EjxPhLpkblcrSFP4jI4+1xn2Bo0eM2BYCXVmXJM7VlTiueEfmzdkjI6r020D7PKzUbQdntIpXDpvZ/uelzESb6pLwCM48JbxJcmSb/5LC7GJY+PItsapW7IJO0Ryb/Ltm2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6CbGHhD; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f6f1677b26so8246965ad.0
        for <live-patching@vger.kernel.org>; Sun, 09 Jun 2024 18:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717983235; x=1718588035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Jrh7GVkc4X7cwu59lzRNFpdx04ob2DTxfS4GtS8YZg=;
        b=l6CbGHhDLi+FnCStNCYr5AnT1is/py3esS9mdhSkAkoZdgU1b/jo29DZX2Df4fs0NG
         1AUKJQQnmwvKsRXRa2n+JrF4IdUT5Ln+/wh9BEGv1akK6vuNu7nZnPFylEe2GkpAECv2
         I3mnxTB1vo8K9+c9JkkNCnoclRJ3qnBcpRY9bZUhALefllkKlX6BA94Xq2o7bR6FXWr4
         l4MHZ7gfU38xctRUINhkp2Rh+o2i56+IiYavLGY/4uM88zTj73crnAbSIrx5Lf0/6SSO
         Pje5i7o2NlGN5Yj4auBZCU0BtCzkHLhMXO6AhfAwe4reYXRmVNSWzBH5NAEeP48lOZoh
         4C3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717983235; x=1718588035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Jrh7GVkc4X7cwu59lzRNFpdx04ob2DTxfS4GtS8YZg=;
        b=ghpssBrFyNiemr0x2agFAtskn5dvxB51hBK9CBn6Cw1WfYbCH0vFt7E2A7O96eZQnA
         eqTUQZp1plj9Ll+jp58QVgQiVYpYGqCwlUCA6J33FfZQLRl4FjlQGqPXgklPqTWoKHlr
         4J/pg6e20sHn8qnbazsdUfWV5fbNUOzpECXajC/gaGG5TizwxCouYxCc1PWIhYyhotQa
         cxRLAPsuFD8wuI7uSRWfBnwyC8QkCwll4J/p/DY7qgG58S7ObiZZREapMazTEdsC4gn3
         hj6h2lJ8eEzuADOxDAJNxIOhPyXoTJ+WiDS7ZGNsxPZ+Au880svNkWtDCkJE0LpUOHlB
         pxNQ==
X-Gm-Message-State: AOJu0YzOrDXdICXP+1QElJcSk7kU1j+88Yo3UZBSKvk4EWRgFa9EVo8Q
	0BT06IqGiVel8Nddp2IQF+BoL12u31UwklEayE50JRa4cQ2UqXio
X-Google-Smtp-Source: AGHT+IEVsJ8kklw30i2Ua5csQnCOV4usvfGZ4sReDrND9reMScfMZtxDsr/zdM5XYn88vwRZPJqbhw==
X-Received: by 2002:a17:902:dac7:b0:1f6:f0be:4099 with SMTP id d9443c01a7336-1f6f0be4437mr66593535ad.11.1717983235379;
        Sun, 09 Jun 2024 18:33:55 -0700 (PDT)
Received: from 192.168.124.8 ([125.121.34.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7fd9b4sm71326555ad.281.2024.06.09.18.33.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:33:54 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
Date: Mon, 10 Jun 2024 09:32:34 +0800
Message-Id: <20240610013237.92646-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "replace" sysfs attribute to show whether a livepatch supports
atomic replace or not.

A minor cleanup is also included in this patchset.

v1->v2:
- Refine the subject (Miroslav)
- Use sysfs_emit() instead and replace other snprintf() as well (Miroslav)
- Add selftests (Marcos) 

v1: https://lore.kernel.org/live-patching/20240607070157.33828-1-laoar.shao@gmail.com/

Yafang Shao (3):
  livepatch: Add "replace" sysfs attribute
  selftests/livepatch: Add selftests for "replace" sysfs attribute
  livepatch: Replace snprintf() with sysfs_emit()

 .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
 kernel/livepatch/core.c                       | 17 +++++--
 .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

-- 
2.39.1


