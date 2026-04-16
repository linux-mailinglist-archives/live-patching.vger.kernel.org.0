Return-Path: <live-patching+bounces-2376-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mO7JGKYo4Wl0pwAAu9opvQ
	(envelope-from <live-patching+bounces-2376-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 20:21:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B527D413B34
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 20:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 998C530B7BF4
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 18:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E9331F981;
	Thu, 16 Apr 2026 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AKICb4Ne"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A041291C10
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 18:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776363522; cv=none; b=CoX7B+a9qOF+wuSGWyRK1+hOBpuhJ3ObyPeJVFG8A10rxKINGeQwftdjUWJ+vB9afo/0g3k4R7R7QHM+Qht3Bj/8I5+x6D6y8d0B/HglDrRXWX9pSJ+TE5GmFlEWr1sCULvTFRjNASal5OWZ8qZ6pIdk6cMGrNxcne0vYLahOBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776363522; c=relaxed/simple;
	bh=/JP5B3xtS7Ie5nsMHxaQ37bFOgQhEf6+4x6V9drX/IE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t8eVIXzZuezAK7UuT2GumtAPIKHQgWfq7hhe9a1kYdD6AY37sn9GtkkMZK0lT6pVR+9MluHVdNlhsLBclED3aE5zYXTXKEiZkgf4ddp4DSrQCtXHxjVVwJh+w5Bo9krJ4WAxSfDa4ahFNWhkTaABtFF0SuVUeRzErZxdA9YS4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AKICb4Ne; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b150559bso65927935e9.1
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 11:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776363520; x=1776968320; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/JP5B3xtS7Ie5nsMHxaQ37bFOgQhEf6+4x6V9drX/IE=;
        b=AKICb4NeIlUjYIYB34rNop23COOcSRiz1aUfMNPYhg+1Zk9HJKOVR7sV+7uSWCbIae
         3m3DE8M6FLYylJ4rk8ztFJI0gW3bWYsu/Ag//xw3F7D183VvIn639imispsMh4u05SN2
         K26aRMBnQb5ZAZRp0slKKinLEGUpWVGODK+2mK0HO12Zzgw6k/0V/1S1iZVQSKYO62dB
         rZ8sbn5Q4GiwLFGTke52Zp0usLnuxHhlY7ebjZpPfUTPqF51wU7+1ogDS1xbagDN7UB5
         bAMQJIfRs+9ebEh1d6MoxrTWIkm6raHeL52I9mFjVbkBqjkFlJJEImcRjo0K74Wy/LHD
         acsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776363520; x=1776968320;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JP5B3xtS7Ie5nsMHxaQ37bFOgQhEf6+4x6V9drX/IE=;
        b=G4GKVgNlm8pxj259XpDUTJIqQWcBRd3WJUnhzRy1kR+gMUmS99VTn4EBAg/ufbmHF/
         WJPyjsZM6ADvC2t/JgjhwhVvs+LFSigmTjfc/2xo6ZnIM2fMDdj1F5iobhEnep86VBxp
         /Ff4vO6S34ugBpYAqfrJLTbU/T2I9Edj5HFBGKzTeEJdB+24ZRrlaXJ6rI750pl/p4I3
         MWne6co0ThRIf1lxcNDVSJll8ZQaDaO+mG3vPgt1K3Oc/olTo8xSG33r8N8NxcgEH4EO
         CZka9nLITAf2eRu65B6SSt5v8hTD5moQAa5wIZhoq+wrzHJKEPbhtz84kfz4Oa+E4+Qt
         or7w==
X-Forwarded-Encrypted: i=1; AFNElJ/1CJ1MwqbTsfktrSdzGbSr1ootuD1fF3CTA97+ElkfJ7lBf/DjB4F3IjaT9fXlTBzNTcu7JqfQwudz7o6C@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0eDgO5hiNIWTpvP9ONNUpO41ZudqH4kvVHUCQLFindH4Ifg4y
	1EXfd6joqBZXweRTcOEhMaVn5wsrjIyKUTD8fVDOsND85cGqagYsZStIZrNTZYVGrGk=
X-Gm-Gg: AeBDieuPTW8TDDStbAYmpshO6OK3MMiQ+c96le0ycYTcrtZ82wy6OGSak+g8khpmpQx
	e4csLcW3fG7B6bUAMZ77A978kja7fzMNWKQ2f6XQ6u5B3r7tVIc7w0jL3S0sF5MmbZ5eo0d4HjB
	Uym+5gnV0Umt64WEWE3na3xmhSwVi+uFdaZFxWnxEInyypZ0B+Qj94EYyqPPiRYdppUPW5bPAZ/
	R/KEoeR5SVYta3ruTSg1Ih+f0Jry45rhj9ivqvXZJO5FW9N7KstCAwELoMbqzsMhOBNkSo7+EV5
	/07RJwR5M3/ZgV2+FKcLtZg9BuXZMOb8MrFmmiNP2C2xDqvUXmrtQxd6ilkFpmTyx3ZQBbl3vI+
	0VXYqD+AFwytVBgSGAM4XJE7OthF8jSNPnvHcvNReGXZPDhx31XllxSaXdtev0vqNrkV8nfO300
	OoUXzu5qmxCcKYPMyzuSu2BeYp0hO6hsruPk4LPXIgxgfGZlTOj9opcIiP5L7WHJUpLm29hr87X
	dsg1w==
X-Received: by 2002:a05:600d:6:b0:487:1fc:14f9 with SMTP id 5b1f17b1804b1-488fb27d7dfmr93845e9.15.1776363519720;
        Thu, 16 Apr 2026 11:18:39 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f57da2aesm118706255e9.0.2026.04.16.11.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 11:18:39 -0700 (PDT)
Message-ID: <5fb3ecf5a13bdf459019f6f011f3507593498875.camel@suse.com>
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be
 executed on 4.12 kernels
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah
 Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Thu, 16 Apr 2026 15:18:33 -0300
In-Reply-To: <wrecfrmldslvr4dvtb7hrmi3w6joby4qmray3fd3f4dfc2k2tv@ficeojpjxjop>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
	 <wrecfrmldslvr4dvtb7hrmi3w6joby4qmray3fd3f4dfc2k2tv@ficeojpjxjop>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2376-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B527D413B34
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 2026-04-16 at 10:07 -0700, Josh Poimboeuf wrote:
> On Mon, Apr 13, 2026 at 02:26:11PM -0300, Marcos Paulo de Souza
> wrote:
> > A new version of the patchset, with fewer patches now. Please take
> > a look!
> >=20
> > Original cover-letter:
> > These patches don't really change how the patches are run, just
> > skip
> > some tests on kernels that don't support a feature (like kprobe and
> > livepatched living together) or when a livepatch sysfs attribute is
> > missing.
> >=20
> > The last patch slightly adjusts check_result function to skip dmesg
> > messages on SLE kernels when a livepatch is removed.
>=20
> Why are we adding complexity to support Linux 4.12 in mainline?=C2=A0
> Isn't
> that what enterprise distros are for?

These changes do not add any new complex code, just checks to enable
the tests to run on older kernels. I believe that it would be good for
all enterprises distros if they could run more tests in maintenance
updates of their kernels using the upstream tests.

The changes are not really that big. Some patches were removed from v1
because there were adding checks for out-of-tree messages (like the
last paragraph of the v2 erroneously shows), and another one was to
check if kprobes could live alongside livepatches, which fails for 4.12
kernels.

The patches for this versions introduce only checks to avoid testing
sysfs attributes for kernels that don't supports them.

