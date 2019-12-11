Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D96A11AC5D
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2019 14:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfLKNp7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 Dec 2019 08:45:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:54136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbfLKNp7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 Dec 2019 08:45:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7846AD66;
        Wed, 11 Dec 2019 13:45:57 +0000 (UTC)
Date:   Wed, 11 Dec 2019 14:45:57 +0100
From:   Libor Pechacek <lpechacek@suse.cz>
To:     Vasily Gorbik <gor@linux.ibm.com>, Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 4/4] s390/livepatch: Implement reliable stack tracing
 for the consistency model
Message-ID: <20191211134557.GC4080@fm.suse.cz>
References: <20191106095601.29986-5-mbenes@suse.cz>
 <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
 <alpine.LSU.2.21.1911291522140.23789@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1911291522140.23789@pobox.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 29-11-19 19:16:38, Miroslav Benes wrote:
> On Fri, 29 Nov 2019, Vasily Gorbik wrote:
[...]
> > https://github.com/lpechacek/qa_test_klp seems outdated. I was able to
> > fix and run some tests of it but haven't had time to figure out all of
> > them. Is there a version that would run on top of current Linus tree?
> 
> Ah, sorry. I should have mentioned that. The code became outdated with 
> recent upstream changes. Libor is working on the updates (CCed).

qa_test_klp has been refreshed. Feel free to test and report issues.

Thanks!

Libor
-- 
Libor Pechacek
SUSE Labs                                Remember to have fun...
