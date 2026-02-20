Return-Path: <live-patching+bounces-2064-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHQiFw1smGn4IAMAu9opvQ
	(envelope-from <live-patching+bounces-2064-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 15:13:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC25A16838E
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 15:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FB5030909C6
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 14:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A1434C806;
	Fri, 20 Feb 2026 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ejbJU1I+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19DA34C80D
	for <live-patching@vger.kernel.org>; Fri, 20 Feb 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596771; cv=none; b=dk1sto6aXB5KIInTCFcbsWuvSZ/M+0mKmq7//pHYy+i0Wha1ongmJOASw+JmCis9z6SVJ8eac89alN437MIQP/47P+pv/cBwiy+Hi+Q534tKKbxGiOslcoonRhnHS/KtkPc0S57barOr9ZEtWasSYuLyX2aoyRVvQKw0gDiYNbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596771; c=relaxed/simple;
	bh=2md64ytofqgo4G1D1UhLCcPUCs8ETnPv72SPqDzXeAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oy138EKpk7OCa/ORSmwgYXEk5drAMtzl7Hgo7dfCFXsfoF1pON4O0D7vtIz0b+Ye1e6I9yusYnOJrvsSm0ZV+QcAdVTM0oUT2vvIkLrdw5IqJ7gnmAej7GOsvuxxpdctjNuzRkfpiO3jjnCWWJme2F+Jvijh9WWRXhCkp+adpA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ejbJU1I+; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4359a16a400so1906309f8f.1
        for <live-patching@vger.kernel.org>; Fri, 20 Feb 2026 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771596768; x=1772201568; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jEEkPljREG0e6yeuCAp1Pz6C43CVga8vk+uSTyLXLvk=;
        b=ejbJU1I+EDffYC4ztHgn2DdZQ3dslZuJXk3xlAx2WewUYHyuC3vVpnIPV74yVnRc6g
         KFqjPlaSxtWZBN7U9diJ0wSrDssOfPQ6z0/3c3ZbmH1bgAK3BUl4y8oPq6aTHL/PTJYG
         0ViDY18lySXKlpwYBPhxhCYXfoMEc5NLk9r9+7tKWXG2BPKzONqXp7u6aGeBFNndN6y/
         vOW+oFa/TUXC9huonzdLDwBScqOhjKwaLzVdi+5jxjlWWx40GlSCFxIKSSz0hB7v8y6b
         oZ6lTtwLDNGLaDBT0iSUwAV2Wf1mZdbDXn4i+ztE0CD/h2sUVUuVA3sUHBqysYA3f0Mb
         MHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771596768; x=1772201568;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jEEkPljREG0e6yeuCAp1Pz6C43CVga8vk+uSTyLXLvk=;
        b=Lg+NYLH696rUEE1GLsfUibQxJPpRTlYpiDoKQdK2JxCLkcee0MxDis8dETd7lb83U7
         1DY8zFknVx9WFkeNOqSLA9YEpsTRP0HBf09DBEolD6Bqj58KRvAlslA6BL7RrA0RYcBf
         YgPMr//atTOsf+1AN4lb5zqo0bKOjyqRReddIF3sblQc+ElqTWRdAzYiHAEWxnVNGVGp
         xIhRE0FkBxpKaLIOHdJXk1NqS9jZ4fn0JqyP+bctRI3eMBBOVQhAd7Yu4s0D97eFeNHN
         JnStyBU2EQ6uDrcAQsKzDy3YGxuyvqr1uz9pHSTrdLlO05aMa1csSfE65SQNcmP9TeHg
         urSg==
X-Gm-Message-State: AOJu0YxYjHydWJSy3HElKRJuKlNSIeY0eDgvQVQR/QGBlzR7IickZXKy
	1JI8Pkag09oFjr56OupY68j1JDwT3S0ttrXXELzmyh3zLB6Luveouq1Mv6cKoxiaWYw=
X-Gm-Gg: AZuq6aLbbbPKBaJKzoFJRFbaSAQjVgUKDT83W/LqI7cgMcdJ1mYSspeaGE/BHVGLExV
	bVARZOS9Rc6+lIkl3gXYSwheq4qBjy+TPo7u2UYZu1J/2NOh+lAgAa3p6udKyUQXhd3CmaYu6Zp
	33PDuiEvDl+v4jw8ym5iCq4QBoASK7PtJXR/vj1BCF63DysxGMothuoDLU4SLQ/0+YQA33J25EH
	lDbS1R/oQ2mUWF36tfWwDHszgNNcwsSltgwoKj68y5BoDe8JlbIAmawupfUH8m1puIBm88UcMRP
	vy26eo9ie53VuI5glVYXVciDJdFkZT23RIZER7CZdXiQm80EHE7BUorJvCKKI5t/egGsHapAGht
	OXBaOjJUVVERYUN05YxN1vEKQ5pfsB2B4jmep3mmOTpzWQzq2NMJS74KXYbk1ZDY5snwy9FEiDx
	UobtrvhaAmzmEVfxOUgWW7
X-Received: by 2002:a05:6000:2301:b0:437:678b:83c2 with SMTP id ffacd0b85a97d-4396f189eadmr19877f8f.54.1771596767842;
        Fri, 20 Feb 2026 06:12:47 -0800 (PST)
Received: from [127.0.0.1] ([2804:5078:822:3100:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b2d1sm60119173f8f.4.2026.02.20.06.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 06:12:47 -0800 (PST)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 20 Feb 2026 11:12:34 -0300
Subject: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround heredoc
 on older bash
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
In-Reply-To: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771596757; l=1061;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=2md64ytofqgo4G1D1UhLCcPUCs8ETnPv72SPqDzXeAg=;
 b=HHrucUUJHPEYEpVG0/tc4hROqI0nwjtNy9OQC3i47BR+EGbsZw8+fl0tzRFfiFRTi/PSRtxL0
 YDBcY5AvBogAdMushsXKWxg9JGQjV0TQHeLldsIsgUrJNndK/VXN7dD
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2064-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EC25A16838E
X-Rspamd-Action: no action

When running current selftests on older distributions like SLE12-SP5 that
contains an older bash trips over heredoc. Convert it to plain echo
calls, which ends up with the same result.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 8ec0cb64ad94..45ed04c6296e 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -96,10 +96,8 @@ function pop_config() {
 }
 
 function set_dynamic_debug() {
-        cat <<-EOF > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
-		file kernel/livepatch/* +p
-		func klp_try_switch_task -p
-		EOF
+	echo "file kernel/livepatch/* +p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
+	echo "func klp_try_switch_task -p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
 }
 
 function set_ftrace_enabled() {

-- 
2.52.0


