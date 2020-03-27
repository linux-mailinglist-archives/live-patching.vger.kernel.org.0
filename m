Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0691957E4
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2020 14:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgC0NU6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Mar 2020 09:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgC0NU6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Mar 2020 09:20:58 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87F2A206DB;
        Fri, 27 Mar 2020 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585315257;
        bh=zSWswf+5WS0gDf6lyvGbAoFBxZ8H5nUIyaS2V82uvYE=;
        h=Date:From:To:cc:Subject:From;
        b=eTvmJSwyVP3L5NOqSRoSEGJ9sy8W3JsSH4iVWLHCKD+JafgyI+EkR12Y49T/LhSdk
         Bg9Ts/L2zopoWJQIG27zGZMi52f8AgdYMXcnYLijilogOnOPIwGdXcu7Yq9jrO11sK
         hXKkWK0YWflL4oNvgnkj5xBPqVyeir+0nDGCWgz0=
Date:   Fri, 27 Mar 2020 14:20:52 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Nicolai Stange <nstange@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc:     ulp-devel@opensuse.org, live-patching@vger.kernel.org
Subject: Live patching MC at LPC2020?
Message-ID: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi everybody,

oh well, it sounds a bit awkward to be talking about any conference plans 
for this year given how the corona things are untangling in the world, but 
LPC planning committee has issued (a) statement about Covid-19 (b) call 
for papers (as originally planned) nevertheless. Please see:

	https://linuxplumbersconf.org/
	https://linuxplumbersconf.org/event/7/abstracts/

for details.

Under the asumption that this Covid nuisance is over by that time and 
travel is possible (and safe) again -- do we want to eventually submit a 
livepatching miniconf proposal again?

I believe there are still kernel related topics on our plate (like revised 
handling of the modules that has been agreed on in Lisbon and Petr has 
started to work on, the C parsing effort by Nicolai, etc), and at the same 
time I'd really like to include the new kids on the block too -- the 
userspace livepatching folks (CCing those I know for sure are working on 
it).

So, please if you have any opinion one way or the other, please speak up. 
Depending on the feedback, I will be fine handling the logistics of the 
miniconf submission as last year (together with Josh I guess?) unless 
someone else wants to step up and volunter himself :)

(*) which is totally unclear, yes -- for example goverment in my country 
    has been talking for border closure lasting for 1+ years ... but it 
    all depends on how things develop of course).


Thanks,

-- 
Jiri Kosina
SUSE Labs
