Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA611573
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 10:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfEBIcF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 04:32:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34327 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbfEBIcF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 04:32:05 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 24D5923026;
        Thu,  2 May 2019 04:32:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 02 May 2019 04:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9T+k5rhFq2p15SaNrTJiSOQ3z5m
        GBYA29Dg0f0zyPFA=; b=LCS9VKDB8hFVerPvgo0PQU4B+6ha5Pi+xRLsKNnjxdQ
        x5/ufZHh1BrbdBn9G3b58HlYhlfffxYjiVa26wUK8qJgFGDlXUS7nCoXJx6Nkbof
        aRg+NAnMFPDukyNrrSPYME62frATSHqItpKxegkFXXuTNOvMk8+qdJ7w2GvKczl0
        0kvm7JN8qSiwE/Xy0j+2AoCktdxvzXhWQ2zr5NNI+ZpxNoaAfZJsH97upMIJ5F+K
        xev2wko0ZLACB6hdty6+G5zaZi2u6l9BQRNIwyh1ehZt9jB01fH5MsmH5hbPy8ZC
        o/vay6fSKkZ4Cc51miPb8wZW+9X4SFQHFRzLyA+2O9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9T+k5r
        hFq2p15SaNrTJiSOQ3z5mGBYA29Dg0f0zyPFA=; b=guWCvW61i6EowDvseB24sm
        EtLzX3+mMiYdj7D5pH/vBvDRws0JtdhB0BiQ4lVGn1l+R+MWZGgbVGzU5mFcalr4
        hCQfJm6s0MqocJEuMNXY/us4RnqF50twCG6KmlqI3rfiJazfoueOsu0/MYMF5w4l
        zvVly3YsF4P7kD2Q+2s0kGD8dcxwwCt0BaYY2XDypEAneouqU/VuvxZulqqEDWnJ
        tq0M5AVOVO6y+7z1CZPkuENug1EEtvqfUFQ3kk1g8msEaK4MH8hmv9WP4xZVpwz+
        yUZ5Ap2Z/B0MIKGxOLokVNoIZrYWD2hbbDlpZjNxgOkl40NH/E5VAJscNx/GGRUg
        ==
X-ME-Sender: <xms:A6vKXBqdFENsK-Y8vFlXq4WRa87p9OHrxYZ7EOgOwQnRNPAYwJCgeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfkphepuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmvgesthhosghinhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:A6vKXJ-ITQhwgQYDE-mO-5H4th5r39-Q3XqwZT7ZJ193z8NMG5ewzw>
    <xmx:A6vKXEN74vdRizpOmlsLgUHuyxAwCm7ChwOUQd9OBLDswxbnbLQR3w>
    <xmx:A6vKXKNO7SCvVBINoNtn2NC-u_xjYvZOb0bPN0T-8RhlW1NLTC1n0w>
    <xmx:BKvKXLlinelSkvnmO0Ix6gEbhxNNa8hinddUJ0PHufFISoqFN6Vh7A>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64262E4625;
        Thu,  2 May 2019 04:32:02 -0400 (EDT)
Date:   Thu, 2 May 2019 18:31:27 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] livepatch: Do not manually track kobject
 initialization
Message-ID: <20190502083127.GC18363@eros.localdomain>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-6-tobin@kernel.org>
 <20190502071232.GB16247@kroah.com>
 <20190502073044.bfzugymrncnaajxe@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502073044.bfzugymrncnaajxe@pathway.suse.cz>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 02, 2019 at 09:30:44AM +0200, Petr Mladek wrote:
> On Thu 2019-05-02 09:12:32, Greg Kroah-Hartman wrote:
> > On Thu, May 02, 2019 at 12:31:42PM +1000, Tobin C. Harding wrote:
> > > Currently we use custom logic to track kobject initialization.  Recently
> > > a predicate function was added to the kobject API so we now no longer
> > > need to do this.
> > > 
> > > Use kobject API to check for initialized state of kobjects instead of
> > > using custom logic to track state.
> > > 
> > > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > > ---
> > >  include/linux/livepatch.h |  6 ------
> > >  kernel/livepatch/core.c   | 18 +++++-------------
> > >  2 files changed, 5 insertions(+), 19 deletions(-)
> > > 
> > > @@ -626,7 +626,7 @@ static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
> > >  		list_del(&obj->node);
> > >  
> > >  		/* Might be called from klp_init_patch() error path. */
> > > -		if (obj->kobj_added) {
> > > +		if (kobject_is_initialized(&obj->kobj)) {
> > >  			kobject_put(&obj->kobj);
> > >  		} else if (obj->dynamic) {
> > >  			klp_free_object_dynamic(obj);
> > 
> > Same here, let's not be lazy.
> > 
> > The code should "know" if the kobject has been initialized or not
> > because it is the entity that asked for it to be initialized.  Don't add
> > extra logic to the kobject core (like the patch before this did) just
> > because this one subsystem wanted to only write 1 "cleanup" function.
> 
> We use kobject for a mix of statically and dynamically defined
> structures[*]. And we misunderstood the behavior of kobject_init().
> 
> Anyway, the right solution is to call kobject_init()
> already in klp_init_patch_early() for the statically
> defined structures and in klp_alloc*() for the dynamically
> allocated ones. Then we could simply call kobject_put()
> every time.
> 
> Tobin, this goes deeper into the livepatching code that
> you probably expected. Do you want to do the above
> suggested change or should I prepare the patch?

I'd love for you to handle this one Petr, I'd say its a net gain
time wise that way since if I do it you'll have to review it too
carefully anyways.

So that will mean patch #1 and #5 of this series are dropped and handed
off to you (thanks).  Patch #2 and #3 Greg said he will take.  Patch #4
is not needed.  That's a win in my books :)

Thanks,
Tobin.
