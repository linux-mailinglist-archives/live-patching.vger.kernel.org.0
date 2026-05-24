Return-Path: <live-patching+bounces-2880-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iC7OET2PE2rbDQcAu9opvQ
	(envelope-from <live-patching+bounces-2880-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:52:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C915C5C4D1B
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04C543027967
	for <lists+live-patching@lfdr.de>; Sun, 24 May 2026 23:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3DA3B841F;
	Sun, 24 May 2026 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gBO16XGd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E360B3B840B
	for <live-patching@vger.kernel.org>; Sun, 24 May 2026 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666661; cv=none; b=G7BtLyLuZ7gldIz7275jy2Gn7zfzpK6wn8Z8DzKoimfSnjPVQkaNhlD0f3P2gaMpQAW6LePAEX2r94spC4rd2LIqvUSwEpPWvb6UYa5EKd7JpIYHwjRJPawkjxC9bU5ru+zuEGvkENTr1z5Dd8FCkmgZqRDjtWJbWzNyn09ZlJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666661; c=relaxed/simple;
	bh=ZxjS4k5Wfeeih8LlvyZ7lzC258PmQVKVFUTNNulCANs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ydm6+uv5fP7+x1u/oIuIFcg4Nw9aBwC5PAZCaIpqmKtTDgTmWFXTn6ZRASuDep0ILbyMDf1ijUGTNBv1Z4zb/bGpCfVJNdhnfANojHCLEBit395vOPY6piZwO0JU6kMES+6W9+Wf/K5mgaDBoNnqHmg04sRe43+L8rJ0FvYicck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gBO16XGd; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43fe62837baso5273396f8f.3
        for <live-patching@vger.kernel.org>; Sun, 24 May 2026 16:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779666658; x=1780271458; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lt6lxfl9RFsw6Y0qS/TM2FzLfwTBlZir2fyLBV9fJ4I=;
        b=gBO16XGdEwwQbkNKLfUKiBVtfuQZgqWxfoQ+qm1aWQ4E65c4Rx5KALuzxGlazPR06w
         DbvJPLzicZchgoifZSoplGjqZyxzlHn3gkGzKqmFToZc2uNET2ZdpW8t0uw7Ddugw1xf
         H3KfrgR4RecGP35eXdpoeAtUbr2ihCEVBEyU/se9ORoJHMmRpLztkWW4TDhnEPpSks/4
         n/D40BnCEqxqqUl8LMoariTN/VJ9AzUq9JYamkur6uHas+ah/wmeL7kyoRXlV3IAzadA
         FIxYxWOqBl+p1ugseUi2BwOKuAQ7JA0Q3MLBUAjrJYJwK0D2VUlyJkNwEy9GU8lhpxeV
         BZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779666658; x=1780271458;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lt6lxfl9RFsw6Y0qS/TM2FzLfwTBlZir2fyLBV9fJ4I=;
        b=ak+zBWqR4D/49eqGqanSnHQrR+ttmS4PkGWUN05i03Qtp4PguV8MnJ24i3NEjnjHJM
         mEuA1GzMLG2b2CwxKgVjjQXYdAKzI+nqZG6sEOm4EFRfKrc271VhtqTUL2uyaJHdV6UA
         PWWGvXVO2S+7XMt9dnG4wZO5I7/3bW2FyTPi5WykXigx8JNebqOwWUd+QoNEiPaezLcA
         j7U/T3Tr+t+9Tjgtplt1M1XqbNkzaLG/5UzO9Dvdj4bPbml3TVwpwHFaZlY5fS7xgoAy
         z2QqXp2ArI/Z7FWuvoZqKpBX0Ou5dFRYWSU0Jz4txqDHNafbQa06fpKegOY1FSwI1jco
         oVDg==
X-Gm-Message-State: AOJu0YxFiSGEvAgvUjUWi1cpg/+G4VanqRP+ZdUbYxc7K1pnvBrQUJ5g
	6YX8GME2uoT8bP+whKtaE/easDV9kJqvEHGLq2JDnawW4ZDVW8WavfRLZiQG7cfL7g4=
X-Gm-Gg: Acq92OEbVljMO72CaLC3mQQ5VwoWzd63pzOyWMB35StQK0ZuM6BpCKhWrYO/Z7fnTfF
	rGmlXIU9LdWAxAqlQL/uAoyPqbOzVSfaXyWWjQBIWfovNDGVz93ufWTQFYAqJ8YZnazEWCctAvs
	Dsi9dX8lDV98pCAW2AVDmiiV9VAoFtG51ZUsFr/Ws8GQY1XulfoA6Y2eXkS6uoPVMcWoAylsEov
	//EHRWsFRoJA45LMFaHZHrdnJ59jwngMGElIzbGNjfJGJ3/RvcFBh3CuHm64konaWpSPWtVQb9B
	zcnctcJC64WXi/QLoIXKgNiTD00kAUVLrb7NkO3TXC6V26128dPCHVhtvFkvUEfnReAH2704fpp
	WpXSDq5ALSpOmLkoiWwSnaeJtR/yIXTE4cHUvO9FOdiKUF3b1O/ZNL78BiGFeGc6MiJC1rL22Yn
	pAlNYLw4/yb9+Uehr5pjypqOM6Ot9lXV/gYA==
X-Received: by 2002:a05:6000:400c:b0:45d:d092:aca4 with SMTP id ffacd0b85a97d-45eb38a81b5mr19039850f8f.4.1779666658359;
        Sun, 24 May 2026 16:50:58 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9de2dsm21698074f8f.4.2026.05.24.16.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 16:50:58 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Sun, 24 May 2026 20:50:33 -0300
Subject: [PATCH 4/4] selftests: livepatch: Add information about minimum
 kernel support
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260524-livepatch-unload-on-fail-v1-4-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779666636; l=956;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=ZxjS4k5Wfeeih8LlvyZ7lzC258PmQVKVFUTNNulCANs=;
 b=5XrQ0kqgcWWWv8O5MO8yhqPyXestGtE9OHduTomZaCX9su6x9fAEDFWl5BD7+YVaDF/moMqmN
 TMlikFW8tFwAwwa8YLuuiKPyCA3wxEGAWufZ6rklMI8qduGSoNBuT+7
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2880-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Queue-Id: C915C5C4D1B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The current livepatch selftests are compatible with kernel 4.12, so add
a note about it for future developers willing to contribute with new
tests.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/README | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/livepatch/README b/tools/testing/selftests/livepatch/README
index d2035dd64a2b..293f4730b927 100644
--- a/tools/testing/selftests/livepatch/README
+++ b/tools/testing/selftests/livepatch/README
@@ -54,3 +54,6 @@ check_result().  The latter function greps the kernel's ring buffer for
 those strings for result comparison.  Other utility functions include
 general module loading and livepatch loading helpers (waiting for patch
 transitions, sysfs entries, etc.)
+
+All new tests and test modules MUST be compatible with kernel version 4.12 and
+later, including current upstream kernels.

-- 
2.54.0


