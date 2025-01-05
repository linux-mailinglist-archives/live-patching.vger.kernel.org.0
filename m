Return-Path: <live-patching+bounces-958-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 916E3A019DF
	for <lists+live-patching@lfdr.de>; Sun,  5 Jan 2025 15:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC28162766
	for <lists+live-patching@lfdr.de>; Sun,  5 Jan 2025 14:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26B814AD3A;
	Sun,  5 Jan 2025 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R/4y74QM"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3656914B94B
	for <live-patching@vger.kernel.org>; Sun,  5 Jan 2025 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736088701; cv=none; b=LeXoVBEFK4CUB6haDfYdMbtvNKUpflBgblSP2Bzx1FG4d86a+Wm//8jh0fCrmFRRDmgftij2TScAg1m8TzAe/+cX8YIKjwBHVtGJuMvVwJ0Z0UsY6XRy8ltNg7FJ5sq4gsghFowRlU26g1Co0CgRsk5Cra05c887FSjYlWtDG4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736088701; c=relaxed/simple;
	bh=AC4kRQZF6noDVVckYqn9QqQKhf9azMUkl6s7EdfNorI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bG3h9ocvcuCsvrG/bt2kFmW707Fm9XTNP+bbrkchbkprRk/b+PFLGXkEZ+1FVGTjgK88JXDhTYUU8u5zIThRzOzltyQqL8ic6WsV+DjUgFOMVmAWF3q+JWGMJIeBEUuKhQJ3rQ5JYi11B/qLFnMowfBuMoplEHYIwLsWHnafJmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R/4y74QM; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3862f32a33eso6173444f8f.3
        for <live-patching@vger.kernel.org>; Sun, 05 Jan 2025 06:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736088697; x=1736693497; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d4ftGznrfcVHgy3LbDB7TWfLC3X5H3QHzuaPq83JQYs=;
        b=R/4y74QMcQ3mAbH0L7NAkLieKBUlqhUIygi44rakol7aXnsqF32skoDi/I0qDpjgDM
         A8N65scrQRW9Z2yCeD7cz8EEEFsq4smHfOg1TEZJoZnLC1uGHOWfenfSIBe+arxjquxT
         5wqe+jl9fiiZs8jOgSgAuozYqgS/ftgKOiCezCkP43uS9dq7U9Qgz66d6zUCyGEEXxSi
         BZ0jNKDE7H6NI1lntSBgWANMQpbK2v+eSGi05yOYOuk9BazYKCZEFCTyMYzdCSbiNMMp
         LsXlZd/+CVGJ3R7U8kry/eJ/X9tQRCtK9x5/xXUA/54qLTOHAT0OOur77eioOsM+AXUW
         t2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736088697; x=1736693497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4ftGznrfcVHgy3LbDB7TWfLC3X5H3QHzuaPq83JQYs=;
        b=UQcpvd3mFzWDZIwqh5GmvT21sr7SKm4F752tKJ99LcppPMMTQkLPgUQztmoeSrUNR6
         aKFdSwhkXWIKmQ3QrH4XmEdn10MWv9KQCPAtHsIqzwCOrHwbN/p22GQDTvJO3f/xsQpI
         r4RIwT0fF4ps6MnbwSlIaXswA0iIrecCTKI5lsjpUCwu/jiH80dzNyQqv6uEo/8nh/1Z
         jweZY1/fbYSCMHWV42vmD3UdeEcjKxyTqENe9ouVKCWbrmWxDZbsGNbu9Dvyo74r0LRR
         alz39Z3n96smrDjhBPAyCz93SPNsZTYWvaRjhM9G3HYZPnlcxs+ydRGd2Tt1MbYlqi0s
         A61g==
X-Forwarded-Encrypted: i=1; AJvYcCUif82i+MPoU2unrReWPwexKjGEH/eFqoj8HUm8G8NVdDU6aaFWpnc+OsOy6u8mAmKbspkx8tR7YNKZ3kYq@vger.kernel.org
X-Gm-Message-State: AOJu0YyL1tkC3J0sQJWWuMgqq9r7XlroZlpqbBRv+M44tOGBJgwSux94
	eANbDrBKfwtB60Iv/y7GrZ6O5m7FiyhTrp94vqVTEGwHStWfK0vt98KaXUK10p8=
X-Gm-Gg: ASbGnctdcfSq5kWALv+ovftX8cS9e3m4+oeQMbVUyuAsr9xUyZW5uMz6MNyKq0kmL6I
	0SfsRoxz8FhTEY60qnDIKQ+cMFSO2LGmx5RmNDNJZQR38jQMsYl8XVBbgDmqlAut1uTyXS1DzvR
	f4tNdf9xUq7RIVbyh1c1Do+80l8geULkLo9fhFlILJmY5jD77J3ncMsghwN6kdENmoR+CKipo5x
	V6yP47RM++o+d89jJ2XPtsAV+EIXBQoOgaL6e5PD9v8YFY8soUCZ8l25wJr
X-Google-Smtp-Source: AGHT+IFJDzjsPSlXhzYJlpTbmixCAgq4k/85cMn1/VkUofjExNVvbvatnpaW9rHveVYnB2gLD17HEg==
X-Received: by 2002:a05:6000:1fae:b0:385:dea3:6059 with SMTP id ffacd0b85a97d-38a223fd3e5mr44897829f8f.49.1736088697468;
        Sun, 05 Jan 2025 06:51:37 -0800 (PST)
Received: from [10.100.51.161] ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8acb85sm45334326f8f.103.2025.01.05.06.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2025 06:51:37 -0800 (PST)
Message-ID: <c37395e2-1ab5-4175-9920-5144cf60e25e@suse.com>
Date: Sun, 5 Jan 2025 15:51:36 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ROX allocations broke livepatch for modules since 6.13-rc1
To: =?UTF-8?Q?Marek_Ma=C5=9Blanka?= <mmaslanka@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org,
 regressions@lists.linux.dev, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 jpoimboe@kernel.org, pmladek@suse.com
References: <CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/30/24 01:09, Marek Maślanka wrote:
> Hi Mike and others,
> 
> I discovered that the patch "[v7,4/8] module: prepare to handle ROX allocations
> for text" has disrupted livepatch functionality. Specifically, this occurs when
> livepatch is prepared to patch a kernel module and when the livepatch module
> contains a "special" relocation section named
> ".klp.rela.<MODULE_NAME>.<SECTION_NAME>" to access local symbols.

Thank you for the report. It is possible for me to reproduce the issue
on my system. An annoying part is to create the
.klp.rela.<objname>.<secname> data, for which I eventually used one
floating variant of klp-convert [1]. To hit the problem, <objname> must
point to an object that is different from vmlinux. Such relocations are
processed by the livepatch code later than regular module relocations,
as you pointed out after mod->rw_copy is already reset.

I think the bug should be addressed in principle by Mike's recently
posted rework of the feature [2] but unfortunately, its current version
makes my system also unbootable [3].

My reproducer:

$ cat test_klp_livepatch.c
#include <linux/kernel.h>
#include <linux/livepatch.h>
#include <linux/module.h>
#include <linux/seq_file.h>
extern __attribute__((weak)) void *xfs_btree_new_root asm("\".klp.sym.rela.xfs.xfs.xfs_btree_new_root.0\"");
static int livepatch_cmdline_proc_show(struct seq_file *m, void *v) {
        seq_printf(m, "live patched: xfs_btree_new_root=%p\n", &xfs_btree_new_root); return 0; }
static struct klp_func funcs[] = { { .old_name = "cmdline_proc_show", .new_func = livepatch_cmdline_proc_show }, { } };
static struct klp_func xfs_funcs[] = { { } };
static struct klp_object objs[] = { { .funcs = funcs, }, { .name = "xfs", .funcs = xfs_funcs, }, { } };
static struct klp_patch patch = { .mod = THIS_MODULE, .objs = objs, };
static int test_klp_livepatch_init(void) { return klp_enable_patch(&patch); }
static void test_klp_livepatch_exit(void) { }
module_init(test_klp_livepatch_init);
module_exit(test_klp_livepatch_exit);
MODULE_LICENSE("GPL");
MODULE_INFO(livepatch, "Y");
MODULE_AUTHOR("Petr Pavlu <petr.pavlu@suse.com>");
MODULE_DESCRIPTION("Livepatch test: livepatch module");

$ make ...
$ klp-convert test_klp_livepatch.ko test_klp_livepatch.conv.ko  # [1]
# modprobe -a xfs ./test_klp_livepatch.conv.ko

[1] https://lore.kernel.org/live-patching/20240827123052.9002-3-lhruska@suse.cz/
[2] https://lore.kernel.org/linux-modules/20241227072825.1288491-1-rppt@kernel.org/
[3] https://lore.kernel.org/linux-modules/86eba318-464b-4b9b-a79e-64039b17be34@lucifer.local/

-- 
Thanks,
Petr

