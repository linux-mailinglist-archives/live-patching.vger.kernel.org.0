Return-Path: <live-patching+bounces-2895-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NfsD0rBFmrOqgcAu9opvQ
	(envelope-from <live-patching+bounces-2895-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:02:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAC95E2558
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B1BE3301DCE3
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 10:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25673EDAAF;
	Wed, 27 May 2026 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IerDiUMX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755093ED131;
	Wed, 27 May 2026 10:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876150; cv=none; b=P0sOL3cinmJvJEwIC2XDfSu+0gbELHkL1RgrNvL6PLFOrSzAFuUavfEn4d40pQmcoWP/B4DOnOHtx67vobm2KYY5KYxkky7yx9e1nNPlaSD3vzt7doZEtIW9IqCOa9gUIioMCUfmDsiXusFNJgMZLv5oiOMwGZsnRVveWhoaeDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876150; c=relaxed/simple;
	bh=PYX1cxlUf8UVwKS1WwMEbVBP1z6XkprOaLUujII/8II=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bOS9Z1z8WgvFhteMPb0rXj0bDn/smaPz85QQEPqvENTRYEAZT2ApW7T05LtT/BI8tBlaauvYR09OmZJda4fpS7aFhjqm1+z3NCrrUJdSFiC5RXQMrAD+bt2E9c5LfkKfiKmkA19vd6HE1oD3T/rEIWUlZq6MHAeb2ZBGKnc77OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IerDiUMX; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779875996;
	bh=Puxwd/zHsLT9Zqn15gB8jpymWS5iWgiQISfMu0Rxp1w=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=IerDiUMXMnpEl5WOLpK6focgFS7euzCv9009XGMFRPuf8GwQARZDhKYsgrg3Fazi0
	 LZeIgiQyQnJYhpeErVPdfapiqn/uAH6UBqcVA7X+JU8OQFODqZqX6Une6zPnfo/P6F
	 fTo4ZIyW+3LrTPBiZcqyZcXpqtPIYryojQYO9ZH4=
X-QQ-mid: zesmtpgz4t1779875976tfbe5bfca
X-QQ-Originating-IP: hlywEGLp0Eo33lqBLBl8hm2NvT8miW2C8iwGT27xDU0=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 17:59:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3179466971943245431
EX-QQ-RecipientCnt: 10
From: Qiang Ma <maqianga@uniontech.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH] selftests: livepatch: set LC_ALL=C to fix locale-dependent test failure
Date: Wed, 27 May 2026 17:59:29 +0800
Message-Id: <20260527095929.1504032-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: OTgf4KY4LuFySAaRqvY7BdfHCfnpBKMK2n1y2+osBAJ+po20aYNzNAoo
	YNJbgnitzSpplrZzak44nkw4ASLmfc3JndzkHGGwfP3TXwvAsieYeDkg9n0TFjIfk8yL6JW
	n+lAyq2ZM/E85lC9tcgNmca4+n+H2uNx/NGzu3SC0dqSTtn7wIe6sxD291nldffawZ0CYwT
	VFX/xP5gJfoopPLZ+YfRCGn0G3vyDu3SXodaiWzz0s3imtODz8lVlFlrD1PhnNrBofxw7U8
	GXu/T8HjWm9c3PY3DlexxfuxB5KQ53bBZmcn8o72+yxDZkyOfcLnJ7G+WY1eH8FqqDAbQz5
	bpGLlnTwer7jLstt2Zni73bxBDPBngbIHEfevGxctkRrZVxPc5I1wvgfUYVniyesf7vVFl2
	D5zw0iB/DPU/JYPP7gbkfSFGJkwWKHkxsngPw9C1zwYx/WmnnU+YXpJ6VBWCL362xktG1j1
	INEMes5SiF0wds9OkL9HGqNek6LYpOPRBxV1MrQ7lF/1w65khx4zh0fh/+qarWmZEDIjwrJ
	bR6b0WT1DAn8NYldr2+Lc0lGs4iD+Ko685d8iJdNR172hd5ZXRpzEQoW5K5kZ51eJOsypqj
	tjPDDbVzvFwwUz0s/U4o3Byi5YfX2c9m9KXjjJQd2YbT/JeV3bmoomQK08K15SQgsRU+7ob
	FK98yXKpMSK66tz8JiWvE0GCfvN7/k7Zx7/HZPzI2hR90ow7diytH5912b0l2HxXAwNik2i
	KlRsjsUOaJYRf8tiLHopcn6t960AXtjDk4XovucI49p5Bv3a4fxq8h/WBHl2NtocippLZ3k
	xzezDBir1czZAq+tgciDJZI+y2Z2PY2eNH+2+r2KEhQ5flc/vwg4FeVS2XsIII2Uu2Ktaap
	bzo5dqErRgtEvZk3TyyAvBGSivONRrye72BQ9FgkAlMGwfyEyejiClRDk9u+ckspGg0Tt9s
	qGv9mTfPZ/41wF5QJkBL0CUTw6zn1kyzUWSvUR1RB7b1Ifcs6KplH08AjmQo8igy38W7hB/
	i8XB3nxpH6AB3xNuYGMX8m4AIvC6Q7rimZ0AzSHnkYNWRYDayj
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[uniontech.com,none];
	R_DKIM_ALLOW(-0.20)[uniontech.com:s=onoh2408];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2895-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maqianga@uniontech.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[uniontech.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,uniontech.com:email,uniontech.com:mid,uniontech.com:dkim,test-ftrace.sh:url]
X-Rspamd-Queue-Id: CFAC95E2558
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When executing the command
"make -C tools/testing/selftests TARGETS=livepatch run_tests",
the following error message was reported.

TEST: livepatch interaction with ftrace_enabled sysctl ... not ok
...
livepatch: sysctlo
: setting key "kernel.ftrace_enabled": Device or resource busy
livepatch: sysctl: setting key "kernel.ftrace_enabled": 设备或资源忙
...
ERROR: livepatch kselftest(s) failed
not ok 5 selftests: livepatch: test-ftrace.sh # exit=1

To fix it, set LC_ALL=C.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 tools/testing/selftests/livepatch/functions.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 8ec0cb64ad94..ecf27c1120f1 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -4,6 +4,8 @@
 
 # Shell functions for the rest of the scripts.
 
+export LC_ALL=C
+
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
 SYSFS_KERNEL_DIR="/sys/kernel"
-- 
2.20.1


