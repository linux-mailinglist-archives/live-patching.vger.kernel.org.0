Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3444126437
	for <lists+live-patching@lfdr.de>; Wed, 22 May 2019 15:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfEVNAn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 May 2019 09:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43015 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbfEVNAn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 May 2019 09:00:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57F7A2FFC32;
        Wed, 22 May 2019 13:00:24 +0000 (UTC)
Received: from treble (ovpn-122-194.rdu2.redhat.com [10.10.122.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF7BA28558;
        Wed, 22 May 2019 13:00:15 +0000 (UTC)
Date:   Wed, 22 May 2019 08:00:14 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190522130014.yvkbio62meatqvwf@treble>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
 <20190520211931.vokbqxkx5kb6k2bz@treble>
 <20190520173910.6da9ddaf@gandalf.local.home>
 <20190521141629.bmk5onsaab26qoaw@treble>
 <20190521104204.47d4e175@gandalf.local.home>
 <20190521164227.bxdff77kq7fgl5lp@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190521164227.bxdff77kq7fgl5lp@treble>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 22 May 2019 13:00:43 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 21, 2019 at 11:42:27AM -0500, Josh Poimboeuf wrote:
>  void module_enable_ro(const struct module *mod, bool after_init)
>  {
> +	lockdep_assert_held(&text_mutex);
> +

This assertion fails, it turns out the module code also calls this
function (oops).  I may move the meat of this function to a
__module_enable_ro() which the module code can call.

-- 
Josh
