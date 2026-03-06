Return-Path: <live-patching+bounces-2149-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMAKEEjlqmkTYAEAu9opvQ
	(envelope-from <live-patching+bounces-2149-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 15:31:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3CC222B7A
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 15:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CF43E304A7E7
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 14:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8290C31D362;
	Fri,  6 Mar 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aXi9E0SK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C40830595B
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807426; cv=none; b=JrBMSs6B4CFVIJODc9+SXsUXOkDZx9q0/I5wmWaXVTK+7Eq0eKNTOwTkAuvM9pNx1S4KHTe324weFtBaYWEQx6xyCFPPNO+YsUyXkX59CU+J2Eh7kTxRk4YxZ+3pa7odfGKijxhMAiFwZT+BH5DwbBHW/vu2+DsDwf+Pl/e5N4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807426; c=relaxed/simple;
	bh=xHwzPHg2PbancKhv5xB7MyGG0IE0UTSxx1kPLT5Uc5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOYBMFnjOuZr2tF8EGWz6q0Os1UMbzMioL/Ky0hzZlcQOD/u1KUv0WBeoFKrzFek296tI7CQqmbh9VNQNYuw0HFE85IL8Ge9y7K8mEGdLnLKZVx148aMS1H3DwJN9eUM1QkP4Xl/E0JV6HZFjrcSAv9Ap7+G97CJr62NRH6AEQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aXi9E0SK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439c9eb5d36so2844828f8f.2
        for <live-patching@vger.kernel.org>; Fri, 06 Mar 2026 06:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772807423; x=1773412223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a86oWd1bJB3OKdBhHnrQ36OfJNveNdTbDopRkwqfS6Y=;
        b=aXi9E0SKbcu9T+ESl8MYjgAno5lS5nDJjFR7ir598zoClxEX7D2qo55VSbXuwS0QJh
         WqBqDyKDDE92koH7TNdKo4ZXkSumKg9y9yUIz9lvHSaR8yvgyHcmVqXUskTLDh0NovKL
         eD3zXuWJUTQbhZlmKK6YA/8TCrH692de/Gs/500BgOyjaYmTYIeWFeiQSUOAshyH2LBk
         hYpHj8NluloXcsaDr8q+XSI17hof2ndavxt9GHi5/VmRfxnk4xD5u8WfzaMpx/+1jcS7
         8xhkczednhPt983wRS1oQQL8Ndi75c1QayUEIEN0kZKz+4uRCiE9NkfDSn7ZvJjQcu20
         yF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807423; x=1773412223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a86oWd1bJB3OKdBhHnrQ36OfJNveNdTbDopRkwqfS6Y=;
        b=FxsZH8jAPFKXz6DHpX2PifgTIahdJdgDqo04k8WUU8vwF49eGsUMdM+PRyv8ER/Cxj
         aZw0oxFud30/eyL5Om1V0oWoOP3V7euZoqK8/uCMjceq+Nps4/0cuZ2oIH3vcqrek2YU
         K6p4JKOZ4GKqif3iPw5uir2po0uVVEl3FDOpQZ6TdlvAd41ra51dSdKZsjbpy4yYA8jE
         Truq/NQGqKYcjq6BDbZ0hg+/4OjCvakSo9ISUNiHvxY20VTKwE/E69qJmBlaCR3r5Vap
         csvsCBnhRQc/kmyxKmJY1byqijOW63xVv7VK/PKn0cKdR2rY1O9vcBxDTSfMEIzodP9T
         niyg==
X-Forwarded-Encrypted: i=1; AJvYcCXmazKMLfFLizo73JQiYLtbv2rOjoWHiLS8VIxmmzJxLKp5SIJyMSg39ojWLj+eCkIexI/gNQNauOXGaBMo@vger.kernel.org
X-Gm-Message-State: AOJu0YzM1dfPbFG4xtlZr4aGqs6mIWVhipoY4CjSHYzUsCg3WLZg5qWS
	HNgrfm85jHourfjEAaF3IJOqVP24bG+aamAmGenYBD+hVUL0lmGrNoKn+Ru/L0Sj20M=
X-Gm-Gg: ATEYQzxmJi2MTJNHIY7fmgLu9Px618MAyY56j0YjzbRKzM8t6/gW6luWV7N0BZo9JHX
	wAL5s5O+237PJUuOMklkLSJ6AuOAB/TWP+gQT/C5ykGvVm1eFqB5MqAG5trKSoWOXUbOfibJoOJ
	iNvfJKUBaZGrF+fqgMTqlYKHYaa3smFoBY5mZugMpbZA7HIkw9p2LyHGEU1oRbZatqU4QhBp3Z+
	kmqW+gwwwEdfLmwrtF2+l9PjVNhFu6cUPj6FFxAOfjYSd7FxKOFY2pPQlvgdOidT6BFHxbv0fX/
	s4EF181yeBN7gWk2tHgEBsm3oNOWU2dFDL2aw8ifQBfayBunTkw/lZz2XYXPDbQ25zrVq6agEqw
	dXb4905F8c9WRQHKfyhySHiyJziVxkgX0HN3ycDTmMV0zh3lCVHQy5MICDzwOoSdUEqJikhTVTb
	HKr4ipbl/asL54Lk6HEDdcWl6vbQ==
X-Received: by 2002:a05:600c:6992:b0:480:1e9e:f9c with SMTP id 5b1f17b1804b1-4852692785emr36510585e9.10.1772807423422;
        Fri, 06 Mar 2026 06:30:23 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae4b860sm4641780f8f.36.2026.03.06.06.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 06:30:22 -0800 (PST)
Date: Fri, 6 Mar 2026 15:30:20 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
Message-ID: <aark_LapcGkPjrLu@pathway.suse.cz>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
 <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
X-Rspamd-Queue-Id: DB3CC222B7A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2149-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,suse.com:dkim,suse.com:email,pathway.suse.cz:mid]
X-Rspamd-Action: no action

On Fri 2026-02-20 11:12:34, Marcos Paulo de Souza wrote:
> When running current selftests on older distributions like SLE12-SP5 that
> contains an older bash trips over heredoc. Convert it to plain echo
> calls, which ends up with the same result.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

JFYI, the patch has been committed into livepatch.git,
branch for-7.1/ftrace-test.

I have fixed the typo reported by Joe, see
https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/commit/?h=for-7.1/ftrace-test&id=920e5001f4beb38685d5b8cac061cb1d2760eeab

Best Regards,
Petr

