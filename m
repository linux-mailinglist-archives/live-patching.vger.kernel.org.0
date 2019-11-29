Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0630010D97D
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2019 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfK2SQr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Nov 2019 13:16:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:44864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727107AbfK2SQr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Nov 2019 13:16:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7279B071;
        Fri, 29 Nov 2019 18:16:45 +0000 (UTC)
Date:   Fri, 29 Nov 2019 19:16:45 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Vasily Gorbik <gor@linux.ibm.com>
cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 1/2] s390/unwind: add stack pointer alignment sanity
 checks
In-Reply-To: <patch-1.thread-a0061f.git-617139935cc4.your-ad-here.call-01575012971-ext-9115@work.hours>
Message-ID: <alpine.LSU.2.21.1911291533310.23789@pobox.suse.cz>
References: <20191106095601.29986-5-mbenes@suse.cz> <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours> <patch-1.thread-a0061f.git-617139935cc4.your-ad-here.call-01575012971-ext-9115@work.hours>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 29 Nov 2019, Vasily Gorbik wrote:

> From: Miroslav Benes <mbenes@suse.cz>
> 
> ABI requires SP to be aligned 8 bytes, report unwinding error otherwise.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

Signed-off-by: Miroslav Benes <mbenes@suse.cz>

M
