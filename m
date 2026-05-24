Return-Path: <live-patching+bounces-2876-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id FmoaBNeOE2rdDQcAu9opvQ
	(envelope-from <live-patching+bounces-2876-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:50:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 402465C4CBF
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 640B430057A4
	for <lists+live-patching@lfdr.de>; Sun, 24 May 2026 23:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E3F3B3C1F;
	Sun, 24 May 2026 23:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MQWhS1j1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7E136A348
	for <live-patching@vger.kernel.org>; Sun, 24 May 2026 23:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666643; cv=none; b=WGM2dnDpByP61WA1k/lGmIE6hJwU70eSQEyfczMivPfiNAH6f/+0mQsb6FMd5vZRkMe1JT3PeLceilKzAChUsvjonLtA6ITv4ajuYTUBJt6ptlHq4gYXymSHRso9C7o211s/qisdJzV8nosmPK4/tuejLTZPxZoV64rtsVu5M70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666643; c=relaxed/simple;
	bh=+6S3KWYxjE1OVCE70/0Kx/ID8QCiK7g1o1wMXFKquBk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DFo1SZ+iPtpb48UQowGlDzgmTNLb3QLZVkSW7K8/8gnlBFHXTiiesXEYRsZC2px1DNGnOhWKLPYbsgfRw3eOU45qU5bA8XwQe1Ui6cW+ZSlOzWdCakN+EhfR4HUt3Qo1pmkdokLh5kfsKi1kC5Rv0znbtwrIiGFCO28nuAiEeYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MQWhS1j1; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-44b330c5cc6so6901921f8f.1
        for <live-patching@vger.kernel.org>; Sun, 24 May 2026 16:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779666640; x=1780271440; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Du48bloKPi85NDz7Azm/z5kCCgy901q6Y6frP0MyLM=;
        b=MQWhS1j1Pq5bCEtp468lDty9P56YwJdLHVQmHjqUlL81stLBRyaIkpPE6IqHEYv675
         CXzrE1s5GX0ylyZoNWa9XZWz6wVyLjQWWQoKli0xIlH58i5jLuInuhQxxKt6umXyOgHz
         kx6aIoalItto2tCErIeoTbCa7gHNXROmmqqBk3gh6VPkuE5MIbhVzPlTh9vNv4PxTseJ
         gQkL2r8TTShELdFiK5dRihinvABO0sl2+LWIJsFnkglM5fGRncRzuq5+havY8ikHaag4
         wvaXGNbjoVKFrcJeSSeRKieMAbJ26bzm2benpfayAhVQS6iMkPEFMDH3/oqEatgccnzw
         PfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779666640; x=1780271440;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Du48bloKPi85NDz7Azm/z5kCCgy901q6Y6frP0MyLM=;
        b=kpyvWVZsLV69W8+ud4VIW2bCtyH/FuiqpawG5cQaPyHdzXg5Root9UgRN894s+o1P+
         AkTTqhUxoKJ949FNaDMneTPMhd2j+LfKRh/aRS6mYnwDOshIaw2l08cz7VnAMvwXA/7u
         0BjidY84I8m3jUhKgBCP6i+waQldOdp/Q2jRRQEOqpguUYhDyeX7hTaHXk4CUKW6+32x
         ouk9vsMEpDdF8EFq7OfY4fxsnwkxKGJsD/9n9wEf3NMLQskZVR8xY09ksotcurBYUBMT
         vcqWaPgYFlj8otepP1elt0wBTldBYXN8i3fxLV8vGgbTBgzwjkwXMP1IXSuCu2UzhmrI
         QtwQ==
X-Gm-Message-State: AOJu0YxjFwyoQ+I/fWw18sdp9+3VDF5d5UFzbWOnJef8yUb6pwgTbpKo
	zmbUoERRKi/6E7hswo0CzR2xSF/mdYqaLntpwFsdB+QKpY4B6OBUUAMFjElT3bHRQs0=
X-Gm-Gg: Acq92OEjgUB7ULkK8Q1C6QHZGFpLkqoPK3E3PbebWCXhMIPQYHR6ovsicx7xCE2mLel
	6fXYjChN95r8Lft3Q0sDm/omfGEsquJBhFhvOLZ+1L6QWlOQdgcRcvlEHSeRAE9vMcROcewDVpS
	zYShQ0QuyIawnp6ricPgIbXsiW7UZ8/8SIVqkQNqvWQdankTblWSs9QmQbO9ihun4KJ26zAtoF3
	fUh7uwEMoFvw8pC5fmFi8XZvRfpMiZnVU00FFcWIfd4AQym7HaMd0rNBjQ/5tLCbhjE/EDkrXTs
	h6DfIz4dnysdzoCGelOsSfIBpxA2m/5ZTSLF0sIsrcfb9YmFZ5ncF1wp2ynfrG+TmqKjMcyo7gS
	/GX6f34Sv9n5aTTv8AglFr/Bw9dtwEziPEq8JJm6XwWiZHDpSyEEL0BIcvlTuFvJPG0iy4Izg9j
	slUC4CRMqevg3v33svniLqUME=
X-Received: by 2002:a5d:5f4f:0:b0:43d:1bf6:30f7 with SMTP id ffacd0b85a97d-45eb36a1ef3mr21051631f8f.18.1779666640500;
        Sun, 24 May 2026 16:50:40 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9de2dsm21698074f8f.4.2026.05.24.16.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 16:50:40 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 0/4] selftests: livepatch: Support 4.12 kernels
Date: Sun, 24 May 2026 20:50:29 -0300
Message-Id: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMWOE2oC/yXMQQ6DIBBA0auYWTsJtcLCqzQupjDWMQQMKGliv
 HvRLt/i/wMyJ+EMQ3NA4iJZYqh4tA3YmcKHUVw1dKozSiuDXgqvtNkZ9+AjOYwBJxKP2rinop5
 7bQlqviae5HuvX+PfeX8vbLfrB+f5AxlyUe98AAAA
X-Change-ID: 20260506-livepatch-unload-on-fail-56d30a4e45ca
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779666636; l=2415;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=+6S3KWYxjE1OVCE70/0Kx/ID8QCiK7g1o1wMXFKquBk=;
 b=dJrcKsyzQ2StJTfooGE/3C1VmZTXxX+T7CKLABL3pl0JNL/BtH/OwwPOOdxbVR+fOZ9FxYCUu
 rjcV5kjQpMYDuoZyABorIpBx4cASq2uHViMb7q5Qznw3gaLIcWRddsV
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2876-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 402465C4CBF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

One issue that exists since the inception of the livepatch selftests is
the capability of recovering from a failed test: the tested livepatch
modules were kept loaded, interfering with the next tests. The first two
commits introduce a simple mechanism that tracks all loaded modules,
and if the test is aborted, the trap function will disable/unload
the remaining modules. With these changes the test
"livepatch interaction with kprobed function without post_handler" fails
on 4.12 kernels (lacking the feature to have a kprobe a livepatches
to be used alongside), but the loaded modules are unloaded, not
affecting the next tests.

The other patches adapt the test_klp_mod_target.c file to use
module_param_cb and kernel_param_ops structures to test livepatching
of functions in modules. This was done to allow the test to be compiled
on 4.12 kernels. Older kernels lacks proc_create_single function, and
to adapt the code for older versions would require ifdefs, which are
not desirable.

I tested these changes using the current upstream kernel and kernel
from SLE 12-SP5 (kernel 4.12). The test-kprobe.sh test fails on 4.12 due
to the missing capability of livepatch and kprobes to be used together.
The result is that now selftests is able to unload the modules loaded,
and continue with the next tests. For the livepatch target test, it works
the same for 4.12 and current upstream.

Please test and review!

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
Marcos Paulo de Souza (4):
      selftests: livepatch: Introduce _remove_mod function
      selftests: livepatch: Remove leftover modules when a testcase fails
      selftests: livepatch: Adapt mod_target module to pass on 4.12 kernels
      selftests: livepatch: Add information about minimum kernel support

 tools/testing/selftests/livepatch/README           |  3 ++
 tools/testing/selftests/livepatch/functions.sh     | 35 ++++++++++++++++++++--
 .../testing/selftests/livepatch/test-livepatch.sh  | 23 +++++++-------
 .../livepatch/test_modules/test_klp_mod_patch.c    | 11 ++++---
 .../livepatch/test_modules/test_klp_mod_target.c   | 22 +++++++-------
 5 files changed, 62 insertions(+), 32 deletions(-)
---
base-commit: 8f7168335cb2e438668c5d94eea76621c9a10edd
change-id: 20260506-livepatch-unload-on-fail-56d30a4e45ca

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


