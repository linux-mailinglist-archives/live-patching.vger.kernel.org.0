Return-Path: <live-patching+bounces-990-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F748A11BEE
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAB9A3A6D97
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA431E7C1C;
	Wed, 15 Jan 2025 08:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AwlrNoUb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AwlrNoUb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B071EEA59;
	Wed, 15 Jan 2025 08:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929642; cv=none; b=Q9obOgO1J62wq1YXxJEdw28mXJTkdgiL6HHiL0FfpzRtiaseS8R50/ABbfcyTBoWs14zi6qL84bhlUI8II0Dk+6Zn8JhPHjJ+2FplT/tvg5so9UDBxKiipONgNNzpkSvJCCLi6rnF3aueJNgEYERMlWc3Uf4oKivQhRdvL5RX/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929642; c=relaxed/simple;
	bh=0RHscELgUV1CB9tgGqKMDjmehQ6c0mMx8prEd09pXO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6J5VmSvEJpXRjVbieU7Cx7uQtU110FNi2A+HnlCh8XdqX5XwqumgrmxoA1FU8ZfK05r5tS5AZoLOIGvGosQfAKFCC9zUzleUVYMucohGv0MIjsMNs68KlPB7ETZm3k3J+UqzO2/rZ6tH5m3b1Q+6zvo+K01BcehgvJgF8KXBrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AwlrNoUb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AwlrNoUb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id B4C1F1F37C;
	Wed, 15 Jan 2025 08:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ChL2is7BM7UhqvWBMZxnH0LEK0ucd+/1xXIHgbJhKaQ=;
	b=AwlrNoUbv7I4SrLjqV4cjhjOuLgF17vSdeLcjV/Au/ofZX7dAcmC6jcszcoW1dZ0UYjBJw
	tky7OJA31rAqWzTKljaRnuHNMRK+r1ovT+E2/14fLqmJKP3JQqouaH76aTqTs8jUxstJAf
	JgRYunrLOf9Yewel9/ikEtQj2pHrgAE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ChL2is7BM7UhqvWBMZxnH0LEK0ucd+/1xXIHgbJhKaQ=;
	b=AwlrNoUbv7I4SrLjqV4cjhjOuLgF17vSdeLcjV/Au/ofZX7dAcmC6jcszcoW1dZ0UYjBJw
	tky7OJA31rAqWzTKljaRnuHNMRK+r1ovT+E2/14fLqmJKP3JQqouaH76aTqTs8jUxstJAf
	JgRYunrLOf9Yewel9/ikEtQj2pHrgAE=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 15/19] selftests/livepatch: Do not use a livepatch with the obsolete per-object callbacks in the basic selftests
Date: Wed, 15 Jan 2025 09:24:27 +0100
Message-ID: <20250115082431.5550-16-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj3e56pwiuh8u4wxetmhsq5s5)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,pathway.suse.cz:helo]
X-Spam-Score: -6.80
X-Spam-Flag: NO

The per-object callbacks have been deprecated in favor of per-state
callbacks and will be removed soon.

Do not use the test livepatch with the obsolete callbacks in the basic
livepatch tests. Replace it with the new generic livepatch, which does
not call any callbacks by default.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/livepatch/test-livepatch.sh | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index 6673023d2b66..5e53adb47c58 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -6,7 +6,7 @@
 
 MOD_LIVEPATCH1=test_klp_livepatch
 MOD_LIVEPATCH2=test_klp_syscall
-MOD_LIVEPATCH3=test_klp_callbacks_demo
+MOD_LIVEPATCH3=test_klp_speaker_livepatch
 MOD_REPLACE=test_klp_atomic_replace
 
 setup_config
@@ -172,10 +172,8 @@ livepatch: '$MOD_LIVEPATCH2': patching complete
 % insmod test_modules/$MOD_LIVEPATCH3.ko
 livepatch: enabling patch '$MOD_LIVEPATCH3'
 livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH3': starting patching transition
 livepatch: '$MOD_LIVEPATCH3': completing patching transition
-$MOD_LIVEPATCH3: post_patch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH3': patching complete
 % insmod test_modules/$MOD_REPLACE.ko replace=1
 livepatch: enabling patch '$MOD_REPLACE'
-- 
2.47.1


