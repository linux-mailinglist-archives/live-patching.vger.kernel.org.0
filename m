Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05024236
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfETUqo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 16:46:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfETUqo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 16:46:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA32428DE;
        Mon, 20 May 2019 20:46:38 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B56F65C644;
        Mon, 20 May 2019 20:46:36 +0000 (UTC)
Subject: Re: Oops caused by race between livepatch and ftrace
To:     Johannes Erdfelt <johannes@erdfelt.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190520194915.GB1646@sventech.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
Date:   Mon, 20 May 2019 16:46:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520194915.GB1646@sventech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 20 May 2019 20:46:44 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[ fixed jeyu's email address ]

On 5/20/19 3:49 PM, Johannes Erdfelt wrote:
> [ ... snip ... ]
> 
> I have put together a test case that can reproduce the crash using
> KVM. The tarball includes a minimal kernel and initramfs, along with
> a script to run qemu and the .config used to build the kernel. By
> default it will attempt to reproduce by loading multiple livepatches
> at the same time. Passing 'test=ftrace' to the script will attempt to
> reproduce by racing with ftrace.
> 
> My test setup reproduces the race and oops more reliably by loading
> multiple livepatches at the same time than with the ftrace method. It's
> not 100% reproducible, so the test case may need to be run multiple
> times.
> 
> It can be found here (not attached because of its size):
> http://johannes.erdfelt.com/5.2.0-rc1-a188339ca5-livepatch-race.tar.gz

Hi Johannes,

This is cool way to distribute the repro kernel, modules, etc!

These two testing scenarios might be interesting to add to our selftests 
suite.  Can you post or add the source(s) to livepatch-test<n>.ko to the 
tarball?

> The simple patch of extending the module_mutex lock over the entirety
> of klp_init_object_loaded fixes it from the livepatch side. This
> mostly works because set_all_modules_text_{rw,ro} acquires module_mutex
> as well, but it still leaves a hole in the ftrace code. A lock should
> probably be held over the entirety of remapping the text sections RW.
> 
> This is complicated by the fact that remapping the text section in
> ftrace is handled by arch specific code. I'm not sure what a good
> solution to this is yet.

A lock or some kind of referencing count..  I'll let other folks comment 
on that side of the bug report.

Thanks,

-- Joe
