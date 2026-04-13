Return-Path: <live-patching+bounces-2337-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOzeNakp3WmVaQkAu9opvQ
	(envelope-from <live-patching+bounces-2337-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:36:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D07F03F190A
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6B9943007A63
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF85B34C989;
	Mon, 13 Apr 2026 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MONPj0tT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242AF3346A5
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101184; cv=none; b=cowGQm+0hPNlQ6YN/nZck80sqLpIG7yTw8JbJgRblbx2AO6VQUlIogtnk8iprGhixI3NoZ1fYMsOn5BbkBreCjtXMVc3Goec/d1trf4mW3z+O6OKOWDdVMhXc3LDEFI/gvWhNXLLtwYjOwsGO4HTHVTB2DUsCNivkfXh3te630A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101184; c=relaxed/simple;
	bh=tlNFGMK5G8ttgy6AVZeZhapjuaMcl29X2npFsloWIt4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IV+yd/EYJNdhsIKPVnhNjYokT3lccAhBoAMvrZnRFKFOkn0edWD1JcLJCVXzAuFKCU0XRIOYd7l6or5tbtt73ahug5SVkSOSVIZQN+TOZ4JitNAjecFg8Md4rlx3Ds/5In4Q0yOK2RS3S3eTmXtszRao/lfYBnzrc6qbCFTnf4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MONPj0tT; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a29e6110so51480465e9.3
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101180; x=1776705980; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xfIAEo902tc41YQ+6N7jIsCT6MaMx+Ubc93DD0U02wg=;
        b=MONPj0tTvGFstiEhgBKKPgKbSYUVrgUDkSz1+ownoyaDM37rje++d0kY4wg9EEd19z
         butp9EoWOmIH5K0cV2NGHW6R0JV7RSSv9vgbO7M80mQ7nYZwb28GkmNn4UbczvoKaYPK
         CRc/JCG0MlCqw9urJQdma4hTdqfCBKdwVBnVAxd1YGeYOw4uIrSAlsM//Iu9RfrTpXYr
         he59+VxrZDhz8nfxORV8DF5nW45QtreVHyEWdZgWKpsC+t9TlnzrhkmovX5eMXoqtyBi
         5NoRvzj3cu+cvtmkWdli14fRy4/T65egfvJtoTETLMuShGPeh2zIn8ePHasqcfyQi81x
         9ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101180; x=1776705980;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfIAEo902tc41YQ+6N7jIsCT6MaMx+Ubc93DD0U02wg=;
        b=jAZghqwzF52h0iIPCMZMw2kP4y8ypCi4GaDWve2lVvLwQBqI3tTLGTKHr0p5eIRL5y
         qs8C4HBl+Q3aKkjeW6ibdpzlAdKk+F0SO7UDDvSHTfqMRZzIRcwB/LdJGkSPKKq9R7yn
         gLt66bYjMjgiW//a2j+c7p6ToHkqkjGK7y/zB+0TP96EO2pinOCEJ8Imhd8aqtqL9Ggs
         bPHjlW13S8A7XxR8HtIVJRlQH6NJ9sDi1Ipk9zZq6MUdQgWvREOyB7efxdGkPug5Du1a
         8Xb4cwtBMep3geKQQ+hColwpk+1cTQrOZNCjFyTitmjCaD/HD2w7SP8e6WlzJPZF5lAV
         Awyg==
X-Gm-Message-State: AOJu0YyVlZQXOnGefHwkpKQYYYTaxAXEKi2JK70LcqcULWNl2U5QM2sk
	JNmpKCKXmxePvNnUUoRxXkMF+s9z9LTuq9zG5i7uHvHBqSdZM1g+wv5bwW7QOUc9tlg=
X-Gm-Gg: AeBDietNBmyrV4wdgG62BLrDQJ6UJO3ekB6HN2lhwAK/fVwt5zP7orpMi47XFhAg4QF
	6SMR89uONBfbZ3KUq1maTB1ufcTZPdHo7oz7hZFrs0k7JznWnsilI2IKrO2cYf1+Af4FEYPzNKZ
	eZXV6BwrxONyPJuDVTZPnUiohiBnX3Tb8RppVohZ9vJm/G53ZOiYCKUDImI/q6HFQqhSSk8qs2v
	EMLR9atPl0fPtHwuvVK22dXmEin+fK8Patdmcr0DzpUrMde1RmRBGc9wPsbaYdfKKRRmfE9hwu+
	KM3SZKKp+8jQ+10tV+HI9rfSjRrgws3apGJpq6/kejYAJYH5wFJGA4psoiNGOoOVLsFN0qWWue/
	WokMugdIyGzmfr+Iy/KPHAWScc1Ycni61beQ5QU9H11TsTbJ+eCrdacHIZrPn0WGB3d7nbTMu0O
	iKGc+psq2tRN2RLDJbG2WwNoE190jJ0mydpQ==
X-Received: by 2002:a05:600c:5306:b0:487:59c:2bb8 with SMTP id 5b1f17b1804b1-488d68c3385mr197391985e9.27.1776101180364;
        Mon, 13 Apr 2026 10:26:20 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:20 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Date: Mon, 13 Apr 2026 14:26:11 -0300
Message-Id: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADMn3WkC/22Nyw6CMBBFf4XM2jF9BBBX/IdhAWWQGqSkU4iG8
 O8WdOny5D7OCkzeEsM1WcHTYtm6MYI6JWD6erwT2jYyKKEyoUWBw4SBODC6ocXOvoixK9K0bsy
 FjMohDidPRxB3t+rLPDcPMmF/2hu95eD8+7Aucu/9BFL/EywSBeayNlnbNVqluuSZ6WzcE6pt2
 z598ED7xQAAAA==
X-Change-ID: 20260309-lp-tests-old-fixes-f955abc8ec27
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=2546;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=tlNFGMK5G8ttgy6AVZeZhapjuaMcl29X2npFsloWIt4=;
 b=dgMIwWOoPPxnVBD33RIsUE57uohRERIxr3/vmU7Ina+6wliM2wP5bwsHPuHZgMb/PzJitEex/
 K8M+fOMmz3NCu/I5zzbXUWuIA+SP+l1vUhvf+Kq98mnnRZeekTdzI9U
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2337-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D07F03F190A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A new version of the patchset, with fewer patches now. Please take a look!

Original cover-letter:
These patches don't really change how the patches are run, just skip
some tests on kernels that don't support a feature (like kprobe and
livepatched living together) or when a livepatch sysfs attribute is
missing.

The last patch slightly adjusts check_result function to skip dmesg
messages on SLE kernels when a livepatch is removed.

These patches are based on printk/for-next branch.

Please review! Thanks!

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
Changes in v2:
- Patch descriptions were changed to remove "test-X", since it was polluting the commit subjects (Miroslav Benes)
- Patch 8 was dropped since it was checking for a message from an out-of-tree patch. (Petr Mladek)
- Patch 3 was dropped as should be treated as expected failure for older kernels. (Petr Mladek)
- Patch 2 was changed to use y/n instead of 1/0, since it's more natural to use it.
- Patch 1 was changed to handle ppc and loongson, and error out if dealing with a different architecture that sets
  CONFIG_ARCH_HAS_SYSCALL_WRAPPER and haven't changed the test to include the proper wrapper prefix.
- Patch 4 was changed to invert the return of the bash function to return 1 in failure, like
  a normal bash function (Joe Lawrence)
- Patches 5, 6 an 7 were changed to not split the tests, but to only run the tests
  when the attribute were present (Miroslav Benes)
- Link to v1: https://patch.msgid.link/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com

---
Marcos Paulo de Souza (6):
      selftests: livepatch: Check for ARCH_HAS_SYSCALL_WRAPPER config
      selftests: livepatch: Replace true/false module parameter by y/n
      selftests: livepatch: Introduce does_sysfs_exists function
      selftests: livepatch: Check if patched sysfs attribute exists
      selftests: livepatch: Check if replace sysfs attribute exists
      selftests: livepatch: Check if stack_order sysfs attribute exists

 tools/testing/selftests/livepatch/functions.sh     |  10 ++
 tools/testing/selftests/livepatch/test-kprobe.sh   |   8 +-
 tools/testing/selftests/livepatch/test-sysfs.sh    | 120 ++++++++++++---------
 .../livepatch/test_modules/test_klp_syscall.c      |  17 ++-
 4 files changed, 99 insertions(+), 56 deletions(-)
---
base-commit: 712c0756828becbfc629ff8d8b82deff5d1115e4
change-id: 20260309-lp-tests-old-fixes-f955abc8ec27

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


