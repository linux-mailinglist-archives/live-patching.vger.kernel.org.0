Return-Path: <live-patching+bounces-2921-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLmPBLtFGGr5iAgAu9opvQ
	(envelope-from <live-patching+bounces-2921-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 15:40:11 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CABA5F2DFB
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 15:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 156353027949
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 13:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EDC3F4DF7;
	Thu, 28 May 2026 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L+ObAeqE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C8E3F4DDF
	for <live-patching@vger.kernel.org>; Thu, 28 May 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779975230; cv=none; b=TpjE0Hm0cZuaERpNenbZwJw2Jfbmb/5dQ14kkOtjoUZUJQevPNDLMS05X4Z8RVt6+vABYjbHtxkvv6IzwMhu7YHREHNZ6njsO23d+9PrWN8OUhCqfMPGlUXZf4KrobeHTE6QIv67yKzi8wco1VgogWiU+a8fwfuNGGXopBzfg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779975230; c=relaxed/simple;
	bh=e6IS64LlvzH31ZmTnvUmp+zTDi1i4OKg3KMzKx5frzQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KJ6yTZ9vII0UTbweP99dpwNdNfzhn/klaxyjZlWEyr/kpEhUMWE+MQzmqdFYAagrivD43+p4pFD5m8EMNRIV4RI3CyAcrMg/mmuAYrgyH7gERq+8fRYq884GDuMf25wFNgKBYhimppPkiUTOgP3uC0hYQaxTmlJcDTrWM31DOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L+ObAeqE; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-44e1860558fso8064670f8f.0
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 06:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779975227; x=1780580027; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e6IS64LlvzH31ZmTnvUmp+zTDi1i4OKg3KMzKx5frzQ=;
        b=L+ObAeqE6S+PJZ0hpS24yC4i/tNYh7TOSRa297QaPqsf/6Vbokqjq25Igmo/Xe6kq5
         cMV1tRqVBaRsCxRyRx6QW76NijsTCbBEIbNJPKVBqtEGuCOwSOut7DVNMn5b8sevFaZG
         m0TZbIPSDlh/HsYBXXwmaDAIIWjPsm6Uxc5Or5kYDtZFPs/IhGpT/fcU5pTOAKEMLHi4
         ktqK/DyCx8f2T67r1lIF/jgq2z44e4HcFvkHHN40urqMKmrBBPIRw1NOnPX/gk06/Svs
         GoW3lXNH/U0n+58VZgoUBdR2Avo6Z2unTZDPRfdgVP/42pW3+o42btIAToC54bNZfqwh
         WjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779975227; x=1780580027;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6IS64LlvzH31ZmTnvUmp+zTDi1i4OKg3KMzKx5frzQ=;
        b=gR7ffLLNeRD54tr3LLEY1i4d02uHH1IhDnq2iaxOcuJF/hfeCFyTtqBprhtct7SDO+
         wfqbfT4wYtWOOsYJjhKmGTsQy8jFfbiG/MrvypA4hD1RMWUL7Kuu7x0SqFZ0iTvdngpc
         CAEu9tG1N/Z+HRH6Ieh/R5S0Vv118CiAFXwP8WaAUxrw+9X9eEFXTON/YiWbBMKFjA8V
         XR32KXF5GnAgfcaA1Lmva4YFdcmq3jJ7+490BUK8GSqgXyvkKAtjsZjfzvw+uw82Wp8F
         h/pbno2BI8Jyr8Xlm7hq1lTe3051cM8DECfvz4YliqjYvr6WcTs5lB90Xg+xHy5vs6aW
         5Ozw==
X-Forwarded-Encrypted: i=1; AFNElJ9wwAJPtqYOx4KLYiIjujI6gUp8EB5YRvsZAlfHrAZfMx1TGRckbeFuf0x/bktu2mTZrCxYSCDc5RZ9XHkK@vger.kernel.org
X-Gm-Message-State: AOJu0YyQVKW1qfMQy1hD7BcPl/rmlAbwIc4n4QYvHeQTO3Gn3EnUKCt8
	B1fxaSUaIpiiof8ddlVb1huDwRKOA0pQvE0dWvAGvAsIXP23LfPEYZmiRXM+JvEMW8g=
X-Gm-Gg: Acq92OEZwmhCJfiHW9l+Sw4UwE9m4LC6KlXMHtmO1dJzllxw8ZL0fWIKJcSuZPLYcom
	IoRKIP51HD+1ZAa6VVkbvpSgs815s8y20bAq6zw18SYdnOf9/Qu0tmb0qe18A0hBE5QisPw5IUv
	N+fPgycLpHkV0cIN5ELFU13e0keTVIF0nobrTrQTmKBK9GlxV1Tni5fn44FXbruC0JAhsbzD9Bs
	Djo2c3+w0wmQaQ0/dHF8o7hAps4hxQLMhFcjVgiPvA5AyfrxFh9xWxXj+fVDRa96EJiAaPyY1ly
	GaE6b72jMjN+loQzq/capH3uyq9tmakabL6MbdOsaIjmpVFBJA7/tuNJ78C/k/v5W+KYBkWb5bj
	nkX7mNq2dTz5yCPGYQEXjvfcimshnKV94V7e2GZQlph6FjndUPhxXXnVtOEDCNUAX0DrQzuuXa0
	hY52wBfp5Fb/gcb9M6oQQjjSNd6/pZjEE5PHE7hk1hoM7V2AenGqFyM0FySs2Xxq/qAazJ3l+pw
	aF01g==
X-Received: by 2002:a05:600c:c3cd:20b0:48a:58ae:993b with SMTP id 5b1f17b1804b1-490428c97a1mr317936895e9.16.1779975226585;
        Thu, 28 May 2026 06:33:46 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49092a817d3sm48318915e9.10.2026.05.28.06.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 06:33:46 -0700 (PDT)
Message-ID: <5df8ff7bcf1f85a21eea3d4f74451fe6b57c118d.camel@suse.com>
Subject: Re: [PATCH v2 8/8] selftests/livepatch: Add RISC-V syscall wrapper
 prefix
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Wang Han <wanghan@linux.alibaba.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexandre Ghiti <alex@ghiti.fr>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,  Chen
 Pei <cp0613@linux.alibaba.com>, Andy Chiu <andybnac@gmail.com>, 
 =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?=	 <bjorn@rivosinc.com>, Deepak Gupta
 <debug@rivosinc.com>, Puranjay Mohan	 <puranjay@kernel.org>, Conor Dooley
 <conor.dooley@microchip.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri
 Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,  Petr Mladek
 <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan
 <shuah@kernel.org>,  Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,  Namhyung
 Kim <namhyung@kernel.org>, oliver.yang@linux.alibaba.com,
 xueshuai@linux.alibaba.com, 	zhuo.song@linux.alibaba.com,
 jkchen@linux.alibaba.com, 	linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, 	linux-kselftest@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Date: Thu, 28 May 2026 10:33:34 -0300
In-Reply-To: <20260528082310.1994388-9-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
	 <20260528082310.1994388-9-wanghan@linux.alibaba.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[35];
	FREEMAIL_CC(0.00)[goodmis.org,ghiti.fr,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2921-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,alibaba.com:email,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 5CABA5F2DFB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 2026-05-28 at 16:23 +0800, Wang Han wrote:
> The syscall livepatch selftest resolves and patches a syscall wrapper
> symbol. To use that test for RISC-V livepatch validation, add the
> RISC-V FN_PREFIX definition for ARCH_HAS_SYSCALL_WRAPPER.
>=20
> Without this macro, the syscall livepatch selftest cannot resolve the
> RISC-V target symbol, and the syscall-related livepatch test fails on
> RISC-V.
>=20
> Signed-off-by: Wang Han <wanghan@linux.alibaba.com>

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
> =C2=A0.../testing/selftests/livepatch/test_modules/test_klp_syscall.c | 2
> ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git
> a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> index dd802783ea84..275e4b10cf59 100644
> ---
> a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> +++
> b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> @@ -18,6 +18,8 @@
> =C2=A0#define FN_PREFIX __s390x_
> =C2=A0#elif defined(__aarch64__)
> =C2=A0#define FN_PREFIX __arm64_
> +#elif defined(__riscv)
> +#define FN_PREFIX __riscv_
> =C2=A0#else
> =C2=A0/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> =C2=A0#define FN_PREFIX

