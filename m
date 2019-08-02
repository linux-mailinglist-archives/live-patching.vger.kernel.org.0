Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE2801E3
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2019 22:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437009AbfHBUma (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Aug 2019 16:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfHBUma (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Aug 2019 16:42:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76D00300C032;
        Fri,  2 Aug 2019 20:42:30 +0000 (UTC)
Received: from treble (ovpn-120-177.rdu2.redhat.com [10.10.120.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDD96600D1;
        Fri,  2 Aug 2019 20:42:26 +0000 (UTC)
Date:   Fri, 2 Aug 2019 15:42:24 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Nicolai Stange <nstange@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [Linux Plumbers Conference] Please submit your livepatch LPC topic
 proposals by Monday
Message-ID: <20190802204224.ochmshq2pzler7ms@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 02 Aug 2019 20:42:30 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[ Steven informed me that my original subject looked like spam and he
  almost deleted it.  He has a point.  Resending with a new subject
  which is less likely to induce email delete trigger finger. ]

Hi all,

Sorry for the late notice, but the CfP for LPC microconference topics is
rapidly approaching.  In fact, I just realized the deadline is
officially today, but they're giving us until Monday.

This year, each presenter is supposed to submit their proposal on the
LPC web site.  Here's what we initially proposed:

  https://www.linuxplumbersconf.org/event/4/page/34-accepted-microconferences#lpatch

     5 min Intro - What happened in kernel live patching over the last year
     API for state changes made by callbacks [1][2]
     source-based livepatch creation tooling [3][4]
     klp-convert [5][6]
     livepatch developers guide
     userspace live patching

If one of those topics is yours, or even if you have something else
you'd like to present/discuss, please go ahead and submit a proposal.  I
think this is the link for submitting:

  https://www.linuxplumbersconf.org/login/?next=%2Fevent%2F4%2Fabstracts%2F%23submit-abstract

When planning your talk, please consider Steven Rostedt's sage advice:

  Please avoid presentations. There's not much time per topic thus the
  time spent on a topic needs to be efficient. Slides are allowed, but
  any presentation should only be used to help bring the audience up to
  speed on what you want to accomplish. Focus only on the necessary
  details to allow folks to participate. This should take no more than 5
  minutes (7 tops, but that's stretching it). The important point is
  that slides should be only used to complement a discussion. They
  should not be used to present a new feature or product unless it is
  absolutely necessary for the discussion at hand. All slides and
  "presentations" should be used to help the discussion that follows.

When selecting topics, Jiri and I will prioritize those topics which are
more discussion-based.

Thanks!

-- 
Josh
