Return-Path: <live-patching+bounces-1150-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98984A3038F
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 07:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84C32167609
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 06:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B761E7C3F;
	Tue, 11 Feb 2025 06:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lU/UkW8L"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF641E5B66
	for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 06:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739255096; cv=none; b=HL07JyqR2l69nKrVE51k21vwBpHru/LGA+tVrGOwfs5WK0q3A/NYhJEIc3HWIfGEP/KFdi46xyPpYuWGEGa712p4WNSyFWi7T/3p2CzdSBK+N5DASnm7DeB9jp2F5GkNmuIkBMgfhIX4z+chQwy4s69rjeR9KUSvtXTuCvjwZmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739255096; c=relaxed/simple;
	bh=e0zfzpS8ikdqMe5wUC2M3uOizR5/zwj1ENMWDjJ+UiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEey7DU+EEwsjVcugPEC9KbtZHfacI/jlq48+De+BPnN1LmpdVoZBnA9dom7k0YZiauSDblPvnrPzPS/wIwJAEcE1ctVLjXiDX2FMyAIGKSb83PaQbl3QyLAMLsTFJB/jZI+TMvl9lU0ADMAiG5SkVxK546IFqtD8Xi4EZydOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lU/UkW8L; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f5a224544so41850425ad.0
        for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 22:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739255094; x=1739859894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBGWHYrbxNLUn+1TF+/JAgqFNoQUlo5SIJx01NrxmmY=;
        b=lU/UkW8LDzn4idZ+faS9D7g1UBYeqAUgBhGaJKtYhZF7n90DiUH8Vm9uAx7kw+iyBD
         PYssvQPTrrxXpzoFfSCplhywjAb21fqqbbdV9HhnuybbCX4qquOwsJqZdFVyYguYU2/B
         xWe79snfiKMtVRf0Bu141tRL6SlvoH6pXxGRJX2AXCxAXc3iXl7U5W0ewLwA8wbcLPCy
         YJgl4opGtC8WD2zjSdwsIss5Y6UMlsBRw6deq7Wod+t8tYuPWUDZUX8xnKOGwJEUrt2V
         G72FJnk9gxhS2kDIkSim1fIoZ0jO+x/dJp4Qy/zep/eEmrMrlqMsMB6wsVXDn378t2dj
         HPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739255094; x=1739859894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBGWHYrbxNLUn+1TF+/JAgqFNoQUlo5SIJx01NrxmmY=;
        b=i2ecWjle4fJ7ibOIHJpBswPlkHohcLn5sseXWYIDwasq3D7FjDu4W8ezoo4eZ0GX8X
         Mwj7kF9kgGFvDUTriSs7lMnGmryzoSv2MwsSWGuX4ogz4kuga3cYJ+rey5RYojvh+ESr
         ppG3i8l4cGgg/TjI1RhOUKTy0PahX8dHQPejSY7uqrhPai1Rb7OMenp7SZp6EWHAZgXE
         Y0XENYtSfyGEMnmun0yB2yjTTy8rZcn7G0WrXIQzKb2ScVQ4ufi2I9NrRs79zAEoTw2Q
         8OHXt2AKjlKFjgEY7kjaMkvysTn6GPuHTQYO0TDlqtBdiev1vjS4FWOHGaQqdi59w0tM
         n0cA==
X-Gm-Message-State: AOJu0Yx/SMvVXHjxe0rNvAsvkDpVbXtkR3y4kdDHydCxD5sZrZzRA1OI
	P9xM0TeC8eJPxb2x2EwMXZvWldT8OxqUmUvm83/Je0utQyjTGlBY
X-Gm-Gg: ASbGncui5reRAxjSnBh5TzcIPIaasdIufRsJEsT3BzKKnAUyP+fE1dCkB2Dzdml7kvd
	imuQHDh/FC5hEK1XaaMjwifLLMLBKBywYmyop/zm85FaGFSyYkSrsoN/4dcpXtOjnA3zZCwkrVu
	3BlKlErlJe5i3sGzpHavS68sDKBGDcgAzWRMBLPnlnHp7a0VmOQf+qgmbb1zSWfXSzExc6zfTvE
	npoPxI7yLzQTDpgzGcfO6ZmwglLvU0sKMo6UHu2Xk/+q8O77YXqrMJnScuDhhxpJq/pcPnr1ihh
	DpfRdPtXKOVgj2BDHK7KK++jOb+ZnoZIg14KcK0=
X-Google-Smtp-Source: AGHT+IEeJHTmxnmEB0QMoAtzoDfTP9rD46HdP05pLukOEi7+lAVZ9nAFmbfEH6aulSE2VuFfKWLqsA==
X-Received: by 2002:a17:903:181:b0:216:3c2b:a5d0 with SMTP id d9443c01a7336-21f4e7b2053mr212767025ad.51.1739255093914;
        Mon, 10 Feb 2025 22:24:53 -0800 (PST)
Received: from localhost.localdomain ([58.37.132.225])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f363df2b4sm89016985ad.0.2025.02.10.22.24.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Feb 2025 22:24:53 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 3/3] livepatch: Avoid potential RCU stalls in klp transition
Date: Tue, 11 Feb 2025 14:24:37 +0800
Message-Id: <20250211062437.46811-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250211062437.46811-1-laoar.shao@gmail.com>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the livepatch loading process, several RCU warnings were triggered on
our production servers, as shown below:

[20329161.705294] livepatch: enabling patch 'livepatch_61_release6'
[20329161.713184] livepatch: 'livepatch_61_release6': starting patching transition
[20329172.998661] rcu_tasks_wait_gp: rcu_tasks grace period 1109713 is 10099 jiffies old.
[20329193.049536] rcu_tasks_wait_gp: rcu_tasks grace period 1109717 is 10059 jiffies old.
[20329213.131403] rcu_tasks_wait_gp: rcu_tasks grace period 1109725 is 10037 jiffies old.
[20329213.934005] livepatch: 'livepatch_61_release6': patching complete

The cause of these warnings was that the KLP transition was holding the
tasklist_lock (which is part of the RCU read-side critical section) for
too long, triggering the warning. To resolve this, we should avoid holding
the lock for an extended period. By checking need_resched(), we can ensure
the RCU warning no longer appears.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/transition.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 04704a19dcfe..3d1f8d3d0f5a 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -491,9 +491,18 @@ void klp_try_complete_transition(void)
 			complete = false;
 			break;
 		}
+
+		/* Avoid potential RCU stalls */
+		if (need_resched()) {
+			complete = false;
+			break;
+		}
 	}
 	read_unlock(&tasklist_lock);
 
+	/* The above operation might be expensive. */
+	cond_resched();
+
 	/*
 	 * Ditto for the idle "swapper" tasks.
 	 */
-- 
2.43.5


