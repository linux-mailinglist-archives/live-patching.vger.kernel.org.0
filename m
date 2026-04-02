Return-Path: <live-patching+bounces-2274-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4M81C+k2zmmAmAYAu9opvQ
	(envelope-from <live-patching+bounces-2274-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:29:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F466386ED8
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B5B5B301C6EE
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 09:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975343932CC;
	Thu,  2 Apr 2026 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PK7aYTF2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375B38F646
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 09:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775121989; cv=none; b=pdPMGBgpLF8hq/r+Mx3jho6oWeYOZtS6UuCETxit8Aiz0H+sb0lIs5s4xc7wNVV5U36WQI/XRE5NORVQmOYNsX1n69RfXvPXkAn+pSLJBLXkh6ewMPbDB7r2ovj9fyVOJmTDcwHn0DwMmQET3riSSBGH8nhBeYwMdamz/JE3o7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775121989; c=relaxed/simple;
	bh=4ECgb/AfeI/g65ADzXXjhXc34kvosRuBpZwZRATvnTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OcSiBC0PRZQGNU9QSlXAl6f2Z2VjjU5ZH3bsYIi02cEwFhUl+NjD35LVz0zM1hSBAqMf8uE+F89LuDgP+MzWNyK8slVFk3qufozTr7ck7rQFMSRLdLETLVUqz5hbTcPIP0EA1wvR+ZvpdXTZ2Tv7j433bXznPbCKOpFljK6vkjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PK7aYTF2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d90833cacso346854a91.2
        for <live-patching@vger.kernel.org>; Thu, 02 Apr 2026 02:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775121982; x=1775726782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xJn/mu9tI/GhEXXW9g1aC2S5Xq1EhBmi8P2sfsvCv7U=;
        b=PK7aYTF2nKbGhR80fVoxFVk22YR5yod0PSzWIb3AzHJgjIksMRbn02SaHf4aoIDKXi
         AOyBoWjEhaSFB3ynLqe+0EcAvJeW+GZgqx9M+yF3PC0c2G1tcEDr6QV1PvLNT2eygfsL
         O6lYgU6Uqn1fDjijkiup2AAVfB/qOry1PZ5WUWMilS6Fhj6AtX+4aZ2sijMC0NQLwmIT
         wWOyEn9Aawj3BQjq65DWW0epcftQsbhCv3t34WKIKC4YueVGBAH94JolYW6bXDYsNKc2
         PWf+f2H+QUcAc1SqmP64zRsDnNCBd3aSL64+DqFIo0DX6e2HuOHodcHXkkPXHuKvu69a
         K6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775121982; x=1775726782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJn/mu9tI/GhEXXW9g1aC2S5Xq1EhBmi8P2sfsvCv7U=;
        b=iAS1K1X5hND6pn0qIGtSkPY/9+i7C0rJ6Z9NGBkG/brKwiISXSmOuTKXxEuenwUGdm
         jbpsDa3CyDWAIYsQ7AP2STgd2NS3V86Z76SlgvONREWWqbaO1GWYbr78Tq8aqXBv5sm+
         GXZB8w8I+doK2CuqWayXxDb/kGyXc8PoZcGMTs2FIvkXwQaj3jbWExcfyUU4nkrOUgX7
         YJK/3MpUMAdsHkeNDpvk/yxGFXYk61IrwgBUWT3Q5qCgIfmLbWtiLHczxhOvCmNT+uVi
         JqCZCtnewHWAvQBKg+p7bNQCHF4Kat+c3U/TD7nTfFTdnlfujy5cavpjPsxUY6sWeEGg
         k2Jg==
X-Gm-Message-State: AOJu0Yy/HP87R9AKYr6EvsJ26Pgre3Cmz/HRIX2j4wwoWCcS2YydnH/S
	6qP/GERtA9mJknWmLC92JGaHciCKfqJ0LouQ1kot0L8CExNN/fvoL7ao
X-Gm-Gg: AeBDieuwvTUggxMaZ9tAwCnNISM/hKdJ2qc71R5Y1moixASDtika9rh2+jRjYKZFsmR
	6vwopbhHyMUhFJAw0Cu7TyUm7IL/+vnl2vwPCq96S+FXlHNalMRwY100IXq2WbHxi2+TTyhgot4
	RelD3Hs4k1WulxEZ/UyUKbiMxhMgImmz7CcS26P1o9k+yGINQt+JUcY00Hv8ZnqKphKRx9P0h+p
	N9i2UcaeBeSXnNKPfKo5ByYkyiN/+zhZOnESUWKsnJv/xu3yFzv2fLHCu/GfMgf5PBPj4T644S4
	OubgttsMF3Q0cwlCsReHq8VhGm1Y4Dm+mx6L1zDQQ/CmNaJ0N/fAMBUhvYs/soTsZVy8PQVTucK
	lhe0fRpcj2CZQj1TH7Ld6Vrn0XS1YEdO18T80HIWVUxZBQFjQhYYjTTXUIM/vaDxl8LEtOVdcaf
	BQUCma7A8wShqxK5nR+sIYxnfiIDTJHOxKvsUvxXzbNe/N
X-Received: by 2002:a17:90a:c107:b0:35b:a656:a5fe with SMTP id 98e67ed59e1d1-35dc6e77dcemr6086211a91.3.1775121982115;
        Thu, 02 Apr 2026 02:26:22 -0700 (PDT)
Received: from yafangs-Air ([2409:891f:1aa0:8613:19f3:7bee:2e41:149e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35f50e9sm2227645a91.6.2026.04.02.02.26.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Apr 2026 02:26:21 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	kpsingh@kernel.org,
	mattbobrowski@google.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	yonghong.song@linux.dev
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding for livepatched functions
Date: Thu,  2 Apr 2026 17:26:03 +0800
Message-ID: <20260402092607.96430-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2274-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 8F466386ED8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Livepatching allows for rapid experimentation with new kernel features
without interrupting production workloads. However, static livepatches lack
the flexibility required to tune features based on task-specific attributes,
such as cgroup membership, which is critical in multi-tenant k8s
environments. Furthermore, hardcoding logic into a livepatch prevents
dynamic adjustments based on the runtime environment.

To address this, we propose a hybrid approach using BPF. Our production use
case involves:

1. Deploying a Livepatch function to serve as a stable BPF hook.

2. Utilizing bpf_override_return() to dynamically modify the return value
   of that hook based on the current task's context.

A significant challenge arises when atomic-replace is enabled. In this
mode, deploying a new livepatch changes the target function's address,
forcing a re-attachment of the BPF program. This re-attachment latency is
unacceptable in critical paths, such as those handling networking policies.

To solve this, we introduce a hybrid livepatch mode that allows specific
patches to remain non-replaceable, ensuring the function address remains
stable and the BPF program stays attached.

Furthermore, this mechanism provides a lower-maintenance alternative to
out-of-tree BPF hooks. Given the complexities of upstreaming custom BPF
hooks (e.g., [0], [1]), this hybrid mode allows for the maintenance of
stable, minimal hook points via livepatching with significantly reduced
maintenance burden.

Link: https://lwn.net/Articles/1054030/ [0]
Link: https://lwn.net/Articles/1043548/ [1]

Yafang Shao (4):
  trace: Simplify kprobe overridable function check
  trace: Allow kprobes to override livepatched functions
  livepatch: Add "replaceable" attribute to klp_patch
  livepatch: Implement livepatch hybrid mode

 include/linux/livepatch.h   |  2 ++
 kernel/livepatch/core.c     | 50 +++++++++++++++++++++++++++++++
 kernel/trace/Kconfig        | 14 +++++++++
 kernel/trace/bpf_trace.c    | 14 ++++++---
 kernel/trace/trace_kprobe.c | 49 ++++++++++++------------------
 kernel/trace/trace_probe.h  | 59 +++++++++++++++++++++++++++----------
 6 files changed, 139 insertions(+), 49 deletions(-)

-- 
2.47.3


