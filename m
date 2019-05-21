Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2471A25998
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 23:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfEUVAX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 17:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfEUVAX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 17:00:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C09937EE7;
        Tue, 21 May 2019 21:00:23 +0000 (UTC)
Received: from treble (ovpn-125-173.rdu2.redhat.com [10.10.125.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39180196F6;
        Tue, 21 May 2019 21:00:19 +0000 (UTC)
Date:   Tue, 21 May 2019 16:00:14 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190521210014.aoew7p7y3jbl7na4@treble>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
 <1802c0d2-702f-08ec-6a85-c7f887eb6d14@redhat.com>
 <a2075a5b-e048-4a7b-2813-01ed7e75bde8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a2075a5b-e048-4a7b-2813-01ed7e75bde8@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 21 May 2019 21:00:23 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 21, 2019 at 03:27:47PM -0400, Joe Lawrence wrote:
> BTW, livepatching folks -- speaking of this window, does it make sense for
> klp_init_object_loaded() to unconditionally frob the module section
> permissions?  Should it only bother iff it's going to apply
> relocations/alternatives/paravirt?

Yeah, technically there shouldn't be a need to do the frobbing unless
there are .klp.rela or .klp.arch sections for the given object.  Though
I'm not sure it really matters all that much since loading a livepatch
is a pretty rare event.

-- 
Josh
