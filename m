Return-Path: <live-patching+bounces-2336-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPlxDPei3GkEUgkAu9opvQ
	(envelope-from <live-patching+bounces-2336-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 10:01:59 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DACA73E8AB2
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 10:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A84230117A9
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 08:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D0E37E30D;
	Mon, 13 Apr 2026 08:01:53 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598863559CA;
	Mon, 13 Apr 2026 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776067313; cv=none; b=gweWUX3GUuddP3bEIGVf2KHoyZ8UDyOGZtEKgO7cLKq1zPEWRX+/8OkdhdhikyBfmDQXZ3QXVkHnBd+WUbrmMfYVHdMjeykujGr/WB+39yzk3/5QhzcBPHV746P4vIhX9TZ8qmZ80ONCdxlxmDJXg1RRjoH6jEHSQASgLhb2Bhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776067313; c=relaxed/simple;
	bh=VUnQLH2pPEqvFRZdcj9hGaqbHbCCyp43cVorRQ4b3rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bg3JOOaCYiGLLOoZHGXjS6CvvQB/Y6wvtJQW6z0k+nPoImlE3K9Oty2bGJKYJ9tqNjUmMWyrdVFmPt68jSmJnraQwbGBs2ml65IIEiP0j9QiqfdPZxovveFNic5t78fnNKhCPlTiiqCBbpC/yDqTeuVDQXRiSDg/FxZJXXfmqbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.242.145:0.2069108682
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-221.238.56.48 (unknown [10.158.242.145])
	by mail.189.cn (HERMES) with SMTP id 24E5F4002A1;
	Mon, 13 Apr 2026 16:01:43 +0800 (CST)
Received: from  ([221.238.56.48])
	by gateway-153622-dep-76cc7bc9cd-r45x9 with ESMTP id 33ade6dc9ca54545a389407f17f1d0f0 for rafael@kernel.org;
	Mon, 13 Apr 2026 16:01:46 CST
X-Transaction-ID: 33ade6dc9ca54545a389407f17f1d0f0
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 221.238.56.48
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From: chensong_2000@189.cn
To: rafael@kernel.org,
	lenb@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	viresh.kumar@linaro.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	jason.wessel@windriver.com,
	danielt@kernel.org,
	dianders@chromium.org,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	atomlin@atomlin.com,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org,
	Song Chen <chensong_2000@189.cn>
Subject: [RFC PATCH 0/2] Decouple ftrace/livepatch from module loader via notifier priority and reverse traversal
Date: Mon, 13 Apr 2026 16:01:40 +0800
Message-ID: <20260413080140.180616-1-chensong_2000@189.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2336-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[189.cn];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[189.cn];
	RCPT_COUNT_TWELVE(0.00)[48];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,lists.sourceforge.net,189.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@189.cn,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,189.cn:email,189.cn:mid]
X-Rspamd-Queue-Id: DACA73E8AB2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Song Chen <chensong_2000@189.cn>

This patchset addresses a long-standing tight coupling between the
module loader and two of its key consumers: ftrace and livepatch.

Background:

The module loader currently hard-codes direct calls to
ftrace_module_enable(), klp_module_coming(), klp_module_going() and
ftrace_release_mod() inside prepare_coming_module() and the module
unload path. This hard-coding was necessary because the module notifier
chain could not guarantee the strict call ordering that ftrace and
livepatch require:

  During MODULE_STATE_COMING, ftrace must run before livepatch, so
  that per-module function records are ready before livepatch registers
  its ftrace hooks.

  During MODULE_STATE_GOING, livepatch must run before ftrace, so that
  livepatch removes its hooks before ftrace releases those records.

This symmetric setup/teardown ordering could not be expressed through
the notifier chain because the chain only supported forward (descending
priority) traversal. Without reverse traversal, it was impossible to
guarantee that the GOING order would be the strict inverse of the
COMING order using a single priority value per notifier.

Patch 1 - notifier: replace single-linked list with double-linked list.
Patch 2 - ftrace/klp: decouple from module loader using notifier
priority.

headsup: somehow the smtp of my mailbox doesn't work very well lately, 
if i receive return letter, i have to resend, sorry in advance.

Song Chen (2):
  kernel/notifier: replace single-linked list with double-linked list
    for reverse traversal
  kernel/module: Decouple klp and ftrace from load_module

 drivers/acpi/sleep.c      |   1 -
 drivers/clk/clk.c         |   2 +-
 drivers/cpufreq/cpufreq.c |   2 +-
 drivers/md/dm-integrity.c |   1 -
 drivers/md/md.c           |   1 -
 include/linux/module.h    |   8 ++
 include/linux/notifier.h  |  26 ++---
 kernel/debug/debug_core.c |   1 -
 kernel/livepatch/core.c   |  29 ++++-
 kernel/module/main.c      |  34 +++---
 kernel/notifier.c         | 219 ++++++++++++++++++++++++++++++++------
 kernel/trace/ftrace.c     |  38 +++++++
 net/ipv4/nexthop.c        |   2 +-
 13 files changed, 290 insertions(+), 74 deletions(-)

-- 
2.43.0


