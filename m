Return-Path: <live-patching+bounces-1968-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BdGMFcmgmnPPgMAu9opvQ
	(envelope-from <live-patching+bounces-1968-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 17:46:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 074BCDC318
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 17:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ED5F2300C7C8
	for <lists+live-patching@lfdr.de>; Tue,  3 Feb 2026 16:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 692383242B8;
	Tue,  3 Feb 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CTOMhCZ2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyGPBBEr"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EAB3C1989
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770137158; cv=none; b=SIzGjPAECGn7oipTqAZcHdVIKPWjL/xRczNT6qjrmNVmiyaTEJr2QD/gaBIUPGDAINkwMeNF5Ad2OIREKAszVIgX0Ge60H2rWu29J80JppvLG0ISs81plVIFNtY2ETjJ/iX/mbErYGKeCJAfKuyP25J5Lx8If0ghw6rhr6BSjJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770137158; c=relaxed/simple;
	bh=XyPW2fOr0aKHgHYJAKroq9NvXm7pwqjHvoqC5pGAWFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nu0JKUVs1DNniIlpSGUn4jcBRZ0O8Iu5BxABdMRkNcFoKVbCQcUOGdcSoU7510vi153ZKOMjMpPRiAXwP8rxeF1O/l5qkwF5ak02mXhZvqY9+C1CWhKsEyZKjKHx/dXCI7inwChkDwVIP6BR83n0WgjwhcGyYyDoIEtLxMvzq4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CTOMhCZ2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyGPBBEr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770137155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lNuKyOoNxTJyz8G7eWdWiguj2+C2jJl6BECJfbXO4Rg=;
	b=CTOMhCZ2SYWvWZQsWex1fK9G6GZLVDacMr/YPGDM5aqs+ukKF5EwBaZE4WzoMavbeO4jjq
	xljp/7pKFyvxcoj5wEy4sKq/sarDdYvWoMYPIwXvesXrKOshty8WJt/e+pt/SFzQtlARj0
	YML2OmhipEeLwn2Nu1nmaNKxNobSUfs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-CBsNiTpKMq2sWZ-SJu5u0A-1; Tue, 03 Feb 2026 11:45:54 -0500
X-MC-Unique: CBsNiTpKMq2sWZ-SJu5u0A-1
X-Mimecast-MFC-AGG-ID: CBsNiTpKMq2sWZ-SJu5u0A_1770137154
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c1cffa1f2dso361298885a.1
        for <live-patching@vger.kernel.org>; Tue, 03 Feb 2026 08:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770137154; x=1770741954; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lNuKyOoNxTJyz8G7eWdWiguj2+C2jJl6BECJfbXO4Rg=;
        b=PyGPBBErQ/dR5eVNIwUjPYAQhFIO6v+HSYdz1igMVQYd1MUwqbCDn1AYP4bsxJhyx2
         wz9PLmQAWQjJEf1gXzbs+pSTKNc/lj5A6SQ3/IjZ5a/LhMpALCFxAGtDpQjBNgDPbnaS
         JzBoaqNlcUAZ7wnwj98hRzX+WYi98NyKlYnqptM/1uAbHePjPli7sPOlfAVTrvpliyKY
         j3ubmujjeyaBJJ2Rkqf5K5r5cYDKqQ5nqA7ESKJAY5oWzWsL0RrE4hqdYpC/Mn69aqt3
         VN/Q+ZUYiBNOkdQDhfWWqJL1maJ7sjTpnsWjVm4OAQGTt0Acucw6mUR1E3IUvrwsRvaU
         wIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770137154; x=1770741954;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNuKyOoNxTJyz8G7eWdWiguj2+C2jJl6BECJfbXO4Rg=;
        b=biOc0l9J7EER8LIcglQuTy9HLCN+xBz5EuKQ97eoJiftunV5FsEpZfE6n6McjER0cQ
         aJ++tIal/VAWrM9LVOttF0QZPZqR0MbPIoUdb6kPC4Wc9wyDymZGYrZDcougG9GnrSLa
         kbyjia7fmnKhOaQkgEy0zbtSh2H6gUp/X68XRH4cu4YH3Bcxocxvl25H9ifvfr+2m/O9
         Hld0I28/Ohb3N3L0sZdQwuRITS1gGzP34bN3/HZ87bgi7gxoT8P0ze8E7ApaBHk1pNc8
         I2sv2f8IXjKNFtoROFXSmeyNCZqN6MHKrOz9KB60fHR5BK54cWFYf4PsOGLVSjPTl0B6
         /XVw==
X-Gm-Message-State: AOJu0YwK7I5owDyw3Y4Kfv11ItbzX+Mcs/Oshw4IZzx4DxRF7wmgdMy0
	Yn4b7a/knQ6UjJ0kx3wTx7kvQMiY7AGaTHp4boIptXNkq52Eido3E03CtPr1fF8YSDHYJ/r3eJS
	PQwqAiJag6zUS+HowUK6DL4YEqNg37B+YcHJJdHmkJngR4R3nipb/ik8g7aoHJkr3U2b6y5srF5
	Q=
X-Gm-Gg: AZuq6aKQ3ku+M68atc4y6ndU57fnaBCkiNPEyypDL/PKm4K6nV1viwnPzYxcyWj4zC8
	on+LIDRvQ3Xp/avh09a3pfyk4wUYlBbyuPdakulvKOHOO10yCUoWNsOjpJcXBHf69YIShq9ppuw
	6KRfa9JtOO4akdDUeQJmkfH9ZPzdHQEPaeqtjKOVi+ruuk7fmdA5qem+lKIMevmWatmxaoLdgna
	bnIrAjaqKIrr12jfWbUlFaS5S3e8jHCyeYWcHzWahMoMlqklKb8x9unm50j4tirV+sYfsxqNy8M
	S7bUITJZdiA2WZhIhp/WD5hKYpgiQk29GMyoTm0OIhstRp49PY0ws+D0vii/0UQ4dAVJMkUn23W
	u5wrCLdYXC87wAV9RkiSwAXfBVpBEeF4yBA78Qt8Q5VAeBo21BJj4ymC+jXVsScvBDg==
X-Received: by 2002:a05:620a:17a5:b0:8c0:9cd8:616a with SMTP id af79cd13be357-8ca302e9ec7mr622785a.42.1770137153735;
        Tue, 03 Feb 2026 08:45:53 -0800 (PST)
X-Received: by 2002:a05:620a:17a5:b0:8c0:9cd8:616a with SMTP id af79cd13be357-8ca302e9ec7mr619485a.42.1770137153291;
        Tue, 03 Feb 2026 08:45:53 -0800 (PST)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fa553e1sm7910285a.1.2026.02.03.08.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 08:45:52 -0800 (PST)
Message-ID: <604a8b96-47f2-4986-b602-c7bdf3de7cca@redhat.com>
Date: Tue, 3 Feb 2026 11:45:51 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
 <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
 <aX0W0JWRkLbuQpGY@redhat.com>
 <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
 <72pzjkj4vnp2vp4ekbj3wnjr62yuywk67tavzn27zetmkg2tjh@nkpihey5cc3g>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <72pzjkj4vnp2vp4ekbj3wnjr62yuywk67tavzn27zetmkg2tjh@nkpihey5cc3g>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-1968-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 074BCDC318
X-Rspamd-Action: no action

On 1/30/26 6:02 PM, Josh Poimboeuf wrote:
> On Fri, Jan 30, 2026 at 02:59:53PM -0800, Josh Poimboeuf wrote:
>> On Fri, Jan 30, 2026 at 03:38:40PM -0500, Joe Lawrence wrote:
>>> On Fri, Jan 30, 2026 at 12:05:35PM -0800, Josh Poimboeuf wrote:
>>>> Hm, isn't the whole point of --recount that it ignores the line numbers?
>>>> Or does it just ignore the numbers after the commas (the counts)?
>>>>
>>>
>>> I don't know exactly.  As I continue digging into the test that sent me
>>> down this path, I just found that `git apply --recount` doesn't like
>>> some output generated by `combinediff -q --combine` even with NO line
>>> drift... then if I manually added in corresponding diff command lines
>>> (to make it look more like a .patch file generated by `diff -Nu`), ie:
>>>
>>>   diff -Nu src.orig/fs/proc/array.c src/fs/proc/array.c     <---
>>>   --- src.orig/fs/proc/array.c
>>>   +++ src/fs/proc/array.c
>>>
>>> Suddenly `git apply --recount` is happy with the patch.
>>>
>>> So I suspect that I started with git not liking the hunks generated by
>>> combinediff and drove it to the rebase feature, which solves a more
>>> interesting problem, but by side effect smoothed over this format
>>> issue when it recreated the patch with git.
>>>
>>> Anyway, I think this patch still stands on it's own: perform the same
>>> apply/revert check as what would happen in the fixup steps to fail
>>> faster for the user?
>>
>> If we just run fix_patches() at the beginning then can we just get rid
>> of validate_patches() altogether?
> 
> Or at least validate_patches() could be replaced with
> check_unsupported_patches(), as the apply/revert test wouldn't be needed
> since the actual apply/revert would happen immediately after that in
> fix_patches().
> 

Currently fix_patches runs in short-circuit step (2) after building the
original kernel.  But what if the user runs:

 $ klp-build -T 0001.patch
 $ klp-build -S 2 0002.patch

If we move fix_patches() to step (1) to fail fast and eliminate a
redundant apply/revert, aren't we then going to miss it if the user
jumps to step (2)?

Is there a way to check without actually doing it if we're going to
build the original kernel first?

And while we're here, doesn't this mean that we're currently not running
validate_patches() when skipping to step (2)?

-- 
Joe


